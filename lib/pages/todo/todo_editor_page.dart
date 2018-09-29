import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo.dart';

class TodoEditorPage extends StatelessWidget {
  final Todo todo;

  TodoEditorPage(this.todo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
      body: Center(
        child: Text('Todo Editor'),
      ),
    );
  }
}
