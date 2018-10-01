import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';

class AppModel extends Model {
  final List<Todo> _todos = [
    Todo(
      id: '1',
      title: 'Todo 01',
    ),
    Todo(
      id: '2',
      title: 'Todo 02',
      content: 'Todo 02 Content',
      priority: Priority.Medium,
    ),
    Todo(
      id: '3',
      title: 'Todo 03',
      content: 'Todo 03 Content',
      priority: Priority.High,
    ),
  ];

  List<Todo> get todos {
    return List.from(_todos);
  }

  void addTodo(Todo todo) {
    _todos.add(todo);

    notifyListeners();
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
