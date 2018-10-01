import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/form_inputs/priority_selector.dart';

class TodoEditorPage extends StatelessWidget {
  final Todo todo;

  TodoEditorPage(this.todo);

  _selectPriority(Priority priority) {
    print(priority);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  initialValue: todo != null ? todo.title : '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Content'),
                  initialValue: todo != null ? todo.content : '',
                  maxLines: 5,
                ),
                SizedBox(
                  height: 12.0,
                ),
                PrioritySelector(
                  todo != null ? todo.priority : Priority.Low,
                  _selectPriority,
                )
              ],
            ),
          ),
        ));
  }
}
