import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/widgets/helpers/error_dialog.dart';
import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/form_inputs/toggle_button.dart';
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
    'isDone': false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _selectPriority(Priority priority) {
    _formData['priority'] = priority;
  }

  _toggleDone(bool isDone) {
    _formData['isDone'] = isDone;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        Todo currentTodo = model.currentTodo;
        bool isDone = currentTodo != null && currentTodo.isDone;

        _formData['title'] = currentTodo != null ? currentTodo.title : null;
        _formData['content'] = currentTodo != null ? currentTodo.content : null;
        _formData['priority'] =
            currentTodo != null ? currentTodo.priority : Priority.Low;
        _formData['isDone'] = currentTodo != null ? currentTodo.isDone : false;

        Widget pageContent = Scaffold(
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

              if (currentTodo != null) {
                model
                    .updateTodo(
                  _formData['title'],
                  _formData['content'],
                  _formData['priority'],
                  _formData['isDone'],
                )
                    .then((bool success) {
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ErrorDialog.show(context);
                  }
                });
              } else {
                model
                    .createTodo(
                  _formData['title'],
                  _formData['content'],
                  _formData['priority'],
                  _formData['isDone'],
                )
                    .then((bool success) {
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ErrorDialog.show(context);
                  }
                });
              }
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
                      initialValue:
                          currentTodo != null ? currentTodo.title : '',
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
                      initialValue:
                          currentTodo != null ? currentTodo.content : '',
                      maxLines: 5,
                      onSaved: (value) {
                        _formData['content'] = value;
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ToggleButton(isDone, _toggleDone),
                        PrioritySelector(
                          currentTodo != null
                              ? currentTodo.priority
                              : Priority.Low,
                          _selectPriority,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );

        Stack mainStack = Stack(
          children: <Widget>[pageContent],
        );

        if (model.isLoading) {
          mainStack.children.add(LoadingModal());
        }

        return mainStack;
      },
    );
  }
}
