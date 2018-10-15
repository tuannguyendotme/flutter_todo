import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';

class ShortcutsEnabledTodoFab extends StatefulWidget {
  final AppModel model;

  ShortcutsEnabledTodoFab(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ShortcutsEnabledTodoFabState();
  }
}

class _ShortcutsEnabledTodoFabState extends State<ShortcutsEnabledTodoFab> {
  AppModel _model;

  @override
  void initState() {
    _model = widget.model;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 50.0,
          child: FloatingActionButton(
            heroTag: 'low',
            backgroundColor: Colors.lightGreen,
            child: Icon(Icons.add),
            mini: true,
            onPressed: () {
              _model.setCurrentTodo(Todo(
                id: null,
                title: '',
                userId: _model.user.id,
                priority: Priority.Low,
              ));

              Navigator.pushNamed(context, '/editor');
            },
          ),
        ),
        Container(
          height: 50.0,
          child: FloatingActionButton(
            heroTag: 'medium',
            backgroundColor: Colors.amber,
            child: Icon(Icons.add),
            mini: true,
            onPressed: () {
              _model.setCurrentTodo(Todo(
                id: null,
                title: '',
                userId: _model.user.id,
                priority: Priority.Medium,
              ));

              Navigator.pushNamed(context, '/editor');
            },
          ),
        ),
        Container(
          height: 50.0,
          child: FloatingActionButton(
            heroTag: 'high',
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.add),
            mini: true,
            onPressed: () {
              _model.setCurrentTodo(Todo(
                id: null,
                title: '',
                userId: _model.user.id,
                priority: Priority.High,
              ));

              Navigator.pushNamed(context, '/editor');
            },
          ),
        ),
        FloatingActionButton(
          heroTag: 'main',
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ],
    );
  }
}
