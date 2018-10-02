import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/widgets/form_inputs/priority_selector.dart';

class TodoEditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoEditorPageState();
  }
}

class _TodoEditorPageState extends State<TodoEditorPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'content': null,
    'priority': Priority.Low,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _selectPriority(Priority priority) {
    _formData['priority'] = priority;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Todo'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }

              _formKey.currentState.save();

              String id =
                  model.currentTodo != null ? model.currentTodo.id : '4';
              Todo todo = Todo(
                id: id,
                title: _formData['title'],
                content: _formData['content'],
                priority: _formData['priority'],
              );

              if (model.currentTodo != null) {
                model.updateTodo(todo);
              } else {
                model.createTodo(todo);
              }

              Navigator.pop(context);
            },
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue: model.currentTodo != null
                          ? model.currentTodo.title
                          : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter todo\'s title';
                        }
                      },
                      onSaved: (value) {
                        _formData['title'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Content'),
                      initialValue: model.currentTodo != null
                          ? model.currentTodo.content
                          : '',
                      maxLines: 5,
                      onSaved: (value) {
                        _formData['content'] = value;
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    PrioritySelector(
                      model.currentTodo != null
                          ? model.currentTodo.priority
                          : Priority.Low,
                      _selectPriority,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
