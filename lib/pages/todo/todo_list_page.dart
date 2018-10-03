import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/todo/todo_list_view.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';

class TodoListPage extends StatefulWidget {
  final AppModel model;

  TodoListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _TodoListPageState();
  }
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    widget.model.fetchTodos();

    super.initState();
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
            child: Icon(Icons.add),
            onPressed: () {
              model.setCurrentTodo(null);

              Navigator.pushNamed(context, '/editor');
            },
          ),
          body: Center(
            child: TodoListView(
              model.todos,
              model.setCurrentTodo,
              model.removeTodo,
            ),
          ),
        );

        Stack stack = Stack(
          children: <Widget>[pageContent],
        );

        if (model.isLoading) {
          stack.children.add(LoadingModal());
        }

        return stack;
      },
    );
  }
}
