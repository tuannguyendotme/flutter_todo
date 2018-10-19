import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';
import 'package:flutter_todo/widgets/helpers/confirm_dialog.dart';

class SettingsPage extends StatefulWidget {
  final AppModel model;

  SettingsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  Widget _buildAppBar(BuildContext context, AppModel model) {
    return AppBar(
      title: Text('Settings'),
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

  Widget _buildPageContent(AppModel model) {
    return model.isLoading
        ? LoadingModal()
        : Scaffold(
            appBar: _buildAppBar(context, model),
            body: SwitchListTile(
              value: model.settings.isShortcutsEnabled,
              onChanged: (value) {
                model.toggleIsShortcutEnabled();
              },
              title: Text('Enable Shortcuts'),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return _buildPageContent(model);
      },
    );
  }
}
