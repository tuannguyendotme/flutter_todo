import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/pages/todo/todo_list_page.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScopedModel<AppModel>(
        model: AppModel(),
        child: TodoListPage(),
      ),
    );
  }
}
