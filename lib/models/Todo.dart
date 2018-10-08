import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';

class Todo {
  final String id;
  final String title;
  final String content;
  final Priority priority;
  final bool isDone;
  final String userId;

  Todo({
    @required this.id,
    @required this.title,
    this.content,
    this.priority = Priority.Low,
    this.isDone = false,
    @required this.userId,
  });
}
