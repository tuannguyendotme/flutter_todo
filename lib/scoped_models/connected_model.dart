import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/models/filter.dart';
import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/helpers/priority_helper.dart';

class CoreModel extends Model {
  List<Todo> _todos = [];
  Todo _todo;
  bool _isLoading = false;
  Filter _filter = Filter.All;
  User _user;
}

class TodosModel extends CoreModel {
  List<Todo> get todos {
    switch (_filter) {
      case Filter.All:
        return List.from(_todos);

      case Filter.Done:
        return List.from(_todos.where((todo) => todo.isDone));

      case Filter.NotDone:
        return List.from(_todos.where((todo) => !todo.isDone));
    }

    return List.from(_todos);
  }

  Filter get filter {
    return _filter;
  }

  bool get isLoading {
    return _isLoading;
  }

  Todo get currentTodo {
    return _todo;
  }

  void applyFilter(Filter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setCurrentTodo(Todo todo) {
    _todo = todo;
  }

  Future<Null> fetchTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http
          .get('${Configure.FirebaseUrl}/todos.json?auth=${_user.token}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();

        return;
      }

      final Map<String, dynamic> todoListData = json.decode(response.body);

      if (todoListData == null) {
        _isLoading = false;
        notifyListeners();

        return;
      }

      todoListData.forEach((String todoId, dynamic todoData) {
        final Todo todo = Todo(
          id: todoId,
          title: todoData['title'],
          content: todoData['content'],
          priority: PriorityHelper.toPriority(todoData['priority']),
          isDone: todoData['isDone'],
        );

        _todos.add(todo);
      });

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTodo(
      String title, String content, Priority priority, bool isDone) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> formData = {
      'title': title,
      'content': content,
      'priority': priority.toString(),
      'isDone': isDone,
    };

    try {
      final http.Response response = await http.post(
        '${Configure.FirebaseUrl}/todos.json?auth=${_user.token}',
        body: json.encode(formData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();

        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      Todo todo = Todo(
        id: responseData['name'],
        title: title,
        content: content,
        priority: priority,
        isDone: isDone,
      );
      _todos.add(todo);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> updateTodo(
      String title, String content, Priority priority, bool isDone) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> formData = {
      'title': title,
      'content': content,
      'priority': priority.toString(),
      'isDone': isDone,
    };

    try {
      final http.Response response = await http.put(
        '${Configure.FirebaseUrl}/todos/${currentTodo.id}.json?auth=${_user.token}',
        body: json.encode(formData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();

        return false;
      }

      Todo todo = Todo(
        id: currentTodo.id,
        title: title,
        content: content,
        priority: priority,
        isDone: isDone,
      );
      int todoIndex = _todos.indexWhere((t) => t.id == currentTodo.id);
      _todos[todoIndex] = todo;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> removeTodo(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      Todo todo = _todos.firstWhere((t) => t.id == id);
      int todoIndex = _todos.indexWhere((t) => t.id == id);
      _todos.removeAt(todoIndex);

      final http.Response response = await http.delete(
          '${Configure.FirebaseUrl}/todos/$id.json?auth=${_user.token}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        _todos[todoIndex] = todo;

        _isLoading = false;
        notifyListeners();

        return false;
      }

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> toggleDone(String id) async {
    _isLoading = true;
    notifyListeners();

    Todo todo = _todos.firstWhere((t) => t.id == id);

    final Map<String, dynamic> formData = {
      'title': todo.title,
      'content': todo.content,
      'priority': todo.priority.toString(),
      'isDone': !todo.isDone,
    };

    try {
      final http.Response response = await http.put(
        '${Configure.FirebaseUrl}/todos/$id.json?auth=${_user.token}',
        body: json.encode(formData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();

        return false;
      }

      todo = Todo(
        id: todo.id,
        title: todo.title,
        content: todo.content,
        priority: todo.priority,
        isDone: !todo.isDone,
      );
      int todoIndex = _todos.indexWhere((t) => t.id == id);
      _todos[todoIndex] = todo;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }
}

class UserModel extends CoreModel {
  User get user {
    return _user;
  }

  Future<bool> authenticate(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> formData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${Configure.ApiKey}',
        body: json.encode(formData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();

        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      _user = User(
        id: responseData['localId'],
        email: responseData['email'],
        token: responseData['idToken'],
      );

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  void logout() {
    _todos = [];
    _todo = null;
    _filter = Filter.All;
    _user = null;
  }
}
