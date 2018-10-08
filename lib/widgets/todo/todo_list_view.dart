import 'package:flutter/material.dart';
import 'package:flutter_todo/models/filter.dart';

import 'package:scoped_model/scoped_model.dart';

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
                child: TodoCard(todo),
                background: Container(color: Colors.red),
              );
            },
          );
        } else {
          String emptyText;

          switch (model.filter) {
            case Filter.All:
              emptyText = 'There are no todo yet. Please create one.';
              break;

            case Filter.Done:
              emptyText = 'There are no Done todo yet. Please create one.';
              break;

            case Filter.NotDone:
              emptyText = 'There are no Not Done todo yet. Please create one.';
              break;
          }

          todoCards = Center(
            child: Text(emptyText),
          );
        }

        return todoCards;
      },
    );
  }
}
