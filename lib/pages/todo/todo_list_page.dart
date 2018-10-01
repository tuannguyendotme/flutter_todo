import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/pages/todo/todo_editor_page.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/widgets/todo/todo_list_view.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoListPageState();
  }
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoEditorPage(null),
            ),
          );
        },
      ),
      body: Center(
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, AppModel model) {
            return TodoListView(model.todos, model.removeTodo);
          },
        ),
      ),
    );
  }
}
