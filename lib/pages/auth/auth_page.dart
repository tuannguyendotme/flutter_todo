import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/helpers/error_dialog.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/widgets/ui_elements/rounded_button.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _authenticate(AppModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    bool success =
        await model.authenticate(_formData['email'], _formData['password']);

    if (success) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ErrorDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.85;

    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        Widget pageContent = Scaffold(
          appBar: AppBar(
            title: Text('Todo'),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Container(
                width: targetWidth,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value.isEmpty ||
                              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                        },
                        onSaved: (value) {
                          _formData['email'] = value;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                        },
                        onSaved: (value) {
                          _formData['password'] = value;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RoundedButton(
                            icon: Icon(Icons.edit),
                            label: 'Register',
                            onPressed: () {},
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          RoundedButton(
                            icon: Icon(Icons.lock_open),
                            label: 'Login',
                            onPressed: () => _authenticate(model),
                          ),
                        ],
                      )
                    ],
                  ),
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
