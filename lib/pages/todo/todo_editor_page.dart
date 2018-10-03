import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/widgets/helpers/error_dialog.dart';
import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
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

              if (model.currentTodo != null) {
                model
                    .updateTodo(
                  _formData['title'],
                  _formData['content'],
                  _formData['priority'],
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
