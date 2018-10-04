import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/widgets/helpers/error_dialog.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo/todo_card.dart';

class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        Widget todoCards;

        if (model.todos.length > 0) {
          todoCards = ListView.builder(
            itemCount: model.todos.length,
            itemBuilder: (BuildContext context, int index) {
              Todo todo = model.todos[index];

              return Dismissible(
                key: Key(todo.id),
                onDismissed: (DismissDirection direction) {
                  model.removeTodo(todo.id);
                },
                child: TodoCard(todo, model.setCurrentTodo),
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
      },
    );
  }
}
