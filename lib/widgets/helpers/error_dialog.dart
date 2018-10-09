import 'package:flutter/material.dart';

class ErrorDialog {
  static void show(BuildContext context, [String message]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Something went wrong'),
          content: Text(
              message != null || message != '' ? message : 'Please try again!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            )
          ],
        );
      },
    );
  }
}
