import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/helpers/error_dialog.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/widgets/ui_elements/rounded_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  void _register(AppModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    Map<String, dynamic> authResult =
        await model.register(_formData['email'], _formData['password']);

    if (authResult['success']) {
      Navigator.pop(context);
    } else {
      ErrorDialog.show(context, authResult['message']);
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
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Please enter valid password';
                          }
                        },
                        onSaved: (value) {
                          _formData['password'] = value;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        validator: (value) {
                          if (value != _passwordController.value.text) {
                            return 'Password and confirm password are not match';
                          }
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
                            onPressed: () {
                              _register(model);
                            },
                          ),
                        ],
                      ),
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
