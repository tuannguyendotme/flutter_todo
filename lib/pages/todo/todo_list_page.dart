import 'package:flutter/material.dart';
import 'package:flutter_todo/models/filter.dart';

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
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              model.setCurrentTodo(null);

              Navigator.pushNamed(context, '/editor');
            },
          ),
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                IconButton(
                  icon: Icon(Icons.all_inclusive),
                  color:
                      model.filter == Filter.All ? Colors.black : Colors.white,
                  onPressed: () {
                    model.applyFilter(Filter.All);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  color:
                      model.filter == Filter.Done ? Colors.black : Colors.white,
                  onPressed: () {
                    model.applyFilter(Filter.Done);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.check_box_outline_blank),
                  color: model.filter == Filter.NotDone
                      ? Colors.black
                      : Colors.white,
                  onPressed: () {
                    model.applyFilter(Filter.NotDone);
                  },
                ),
                SizedBox(
                  width: 80.0,
                ),
              ],
            ),
            color: Colors.blue,
            shape: CircularNotchedRectangle(),
          ),
          body: Center(
            child: TodoListView(),
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
