import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/models/filter.dart';
import 'package:flutter_todo/widgets/ui_elements/rounded_button.dart';
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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.lock),
                onPressed: () async {
                  bool confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text('Are you sure to logout?'),
                          contentPadding: EdgeInsets.all(12.0),
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RoundedButton(
                                  label: 'No',
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                RoundedButton(
                                  label: 'Yes',
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      });

                  if (confirm) {
                    model.logout();

                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
              ),
            ],
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                FlatButton(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.all_inclusive,
                          color: model.filter == Filter.All
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'All',
                          style: TextStyle(
                            color: model.filter == Filter.All
                                ? Colors.white
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    model.applyFilter(Filter.All);
                  },
                ),
                FlatButton(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: model.filter == Filter.Done
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Done',
                          style: TextStyle(
                            color: model.filter == Filter.Done
                                ? Colors.white
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    model.applyFilter(Filter.Done);
                  },
                ),
                FlatButton(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.check_box_outline_blank,
                          color: model.filter == Filter.NotDone
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Not Done',
                          style: TextStyle(
                            color: model.filter == Filter.NotDone
                                ? Colors.white
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
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
