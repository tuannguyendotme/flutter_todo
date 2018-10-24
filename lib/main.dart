import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/pages/register/register_page.dart';
import 'package:flutter_todo/pages/settings/settings_page.dart';
import 'package:flutter_todo/pages/auth/auth_page.dart';
import 'package:flutter_todo/pages/todo/todo_editor_page.dart';
import 'package:flutter_todo/pages/todo/todo_list_page.dart';

void main() async {
  final AppModel model = AppModel();
  await model.loadSettings();

  runApp(TodoApp(model));
}

class TodoApp extends StatefulWidget {
  final AppModel model;

  TodoApp(this.model);

  @override
  State<StatefulWidget> createState() {
    return _TodoAppState();
  }
}

class _TodoAppState extends State<TodoApp> {
  AppModel _model;
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model = widget.model;

    _model.autoAuthentication();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: _model,
      child: MaterialApp(
        title: Configure.AppName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.blue,
          brightness: _model.settings.isDarkThemeUsed
              ? Brightness.dark
              : Brightness.light,
        ),
        routes: {
          '/': (BuildContext context) =>
              _isAuthenticated ? TodoListPage(_model) : AuthPage(),
          '/editor': (BuildContext context) =>
              _isAuthenticated ? TodoEditorPage() : AuthPage(),
          '/register': (BuildContext context) =>
              _isAuthenticated ? TodoListPage(_model) : RegisterPage(),
          '/settings': (BuildContext context) =>
              _isAuthenticated ? SettingsPage(_model) : AuthPage(),
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                _isAuthenticated ? TodoListPage(_model) : AuthPage(),
          );
        },
      ),
    );
  }
}
