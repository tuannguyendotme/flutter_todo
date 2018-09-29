import 'package:flutter/material.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo/todo_card.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> todos;

  TodoListView(this.todos);

  @override
  Widget build(BuildContext context) {
    Widget todoCards;

    if (todos.length > 0) {
      todoCards = ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          Todo todo = todos[index];

          return Dismissible(
            key: Key(todo.id),
            onDismissed: (DismissDirection direction) {},
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
