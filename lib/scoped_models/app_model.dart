import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';

class AppModel extends Model {
  final List<Todo> _todos = [];
  Todo _todo;
  bool _isLoading = false;

  List<Todo> get todos {
    return List.from(_todos);
  }

  bool get isLoading {
    return _isLoading;
  }

  Todo get currentTodo {
    return _todo;
  }

  void setCurrentTodo(Todo todo) {
    _todo = todo;
  }

  Future<Null> fetchTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http
          .get('https://flutter-todo-ca169.firebaseio.com/todos.json');

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
          priority: Priority.High,
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
      String title, String content, Priority priority) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> formData = {
      'title': title,
      'content': content,
      'priority': priority.toString()
    };

    try {
      final http.Response response = await http.post(
        'https://flutter-todo-ca169.firebaseio.com/todos.json',
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

  void updateTodo(Todo todo) {
    int todoIndex = _todos.indexWhere((t) => t.id == todo.id);
    _todos[todoIndex] = todo;

    notifyListeners();
  }

  void removeTodo(String id) {
    int todoIndex = _todos.indexWhere((todo) => todo.id == id);
    _todos.removeAt(todoIndex);

    notifyListeners();
  }
}
