import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/pages/todo/todo_editor_page.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  TodoCard(this.todo);

  Color _buildPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.High:
        return Colors.redAccent;

      case Priority.Medium:
        return Colors.amber;

      default:
        return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: _buildPriorityColor(todo.priority),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(4.0),
                bottomLeft: const Radius.circular(4.0),
              ),
            ),
            width: 12.0,
            height: 80.0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                todo.title,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoEditorPage(todo),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
