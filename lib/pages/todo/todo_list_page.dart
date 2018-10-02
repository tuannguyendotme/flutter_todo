import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/widgets/todo/todo_list_view.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoListPageState();
  }
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Todo'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              model.setCurrentTodo(null);

              Navigator.pushNamed(context, '/editor');
            },
          ),
          body: Center(
            child: TodoListView(
              model.todos,
              model.setCurrentTodo,
              model.removeTodo,
            ),
          ),
        );
      },
    );
  }
}
