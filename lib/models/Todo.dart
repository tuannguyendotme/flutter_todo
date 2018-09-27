import 'package:flutter/material.dart';

import 'package:flutter_todo/models/Priority.dart';

class Todo {
  final String title;
  final String content;
  final Priority priority;

  Todo({
    @required this.title,
    this.content,
    this.priority = Priority.Low,
  });
}
