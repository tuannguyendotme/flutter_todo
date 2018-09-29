import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/pages/todo/todo_editor_page.dart';
import 'package:flutter_todo/widgets/todo/todo_list_view.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListPageState();
  }
}

class TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];

  @override
  void initState() {
    setState(() {
      todos = [
        Todo(title: 'Todo 01'),
        Todo(
          title: 'Todo 02',
          content: 'Todo 02 Content',
          priority: Priority.Medium,
        ),
        Todo(
          title: 'Todo 03',
          content: 'Todo 03 Content',
          priority: Priority.High,
        ),
      ];
    });

    super.initState();
  }

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
        child: TodoListView(todos),
      ),
    );
  }
}
