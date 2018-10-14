import 'package:flutter/material.dart';
import 'package:flutter_todo/widgets/helpers/confirm_dialog.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';

class SettingsPage extends StatelessWidget {
  Widget _buildAppBar(BuildContext context, AppModel model) {
    return AppBar(
      title: Text(Configure.AppName),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.lock),
          onPressed: () async {
            bool confirm = await ConfirmDialog.show(context);

            if (confirm) {
              Navigator.pop(context);

              model.logout();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: _buildAppBar(context, model),
          body: Center(
            child: Text('Settings'),
          ),
        );
      },
    );
  }
}
