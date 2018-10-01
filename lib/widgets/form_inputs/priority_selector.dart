import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/widgets/helpers/priority_helper.dart';

class PrioritySelector extends StatefulWidget {
  final Function setPriority;
  final Priority initialPriority;

  PrioritySelector(this.initialPriority, this.setPriority);

  @override
  State<StatefulWidget> createState() {
    return PrioritySelectorState();
  }
}

class PrioritySelectorState extends State<PrioritySelector> {
  Widget _buildItems() {
    List<Container> items = new List<Container>();

    Priority.values.forEach((priority) {
      Color priorityColor = PriorityHelper.buildPriorityColor(priority);

      items.add(Container(
        color: priorityColor,
        width: 60.0,
        height: 60.0,
        child: widget.initialPriority == priority ? Icon(Icons.check) : null,
      ));
    });

    return Row(
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItems();
  }
}
