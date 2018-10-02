import 'package:flutter/material.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/helpers/priority_helper.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final Function setCurrentTodo;

  TodoCard(this.todo, this.setCurrentTodo);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: PriorityHelper.buildPriorityColor(todo.priority),
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
              setCurrentTodo(todo);

              Navigator.pushNamed(context, '/editor');
            },
          )
        ],
      ),
    );
  }
}
