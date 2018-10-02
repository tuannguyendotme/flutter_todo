import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/pages/todo/todo_editor_page.dart';
import 'package:flutter_todo/pages/todo/todo_list_page.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  final _model = AppModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: _model,
      child: MaterialApp(
        title: 'Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) => TodoListPage(),
          '/editor': (BuildContext context) => TodoEditorPage(),
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => TodoListPage(),
          );
        },
      ),
    );
  }
}
