import 'package:flutter/material.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo/todo_card.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> _todos;
  final Function _removeTodo;

  TodoListView(this._todos, this._removeTodo);

  @override
  Widget build(BuildContext context) {
    Widget todoCards;

    if (_todos.length > 0) {
      todoCards = ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (BuildContext context, int index) {
          Todo todo = _todos[index];

          return Dismissible(
            key: Key(todo.id),
            onDismissed: (DismissDirection direction) {
              _removeTodo(todo.id);
            },
            child: TodoCard(todo),
            background: Container(color: Colors.red),
          );
        },
      );
    } else {
      todoCards = Center(
        child: Text('There are no todo yet. Please create one.'),
      );
    }

    return todoCards;
  }
}
