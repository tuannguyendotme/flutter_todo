import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/widgets/helpers/priority_helper.dart';

class PrioritySelector extends StatefulWidget {
  final Function setPriority;
  final Priority initialPriority;

  PrioritySelector(this.initialPriority, this.setPriority);

  @override
  State<StatefulWidget> createState() {
    return _PrioritySelectorState();
  }
}

class _PrioritySelectorState extends State<PrioritySelector> {
  Priority priority;

  @override
  void initState() {
    priority = widget.initialPriority;

    super.initState();
  }

  Widget _buildItems() {
    List<Container> items = new List<Container>();

    Priority.values.forEach((priorityValue) {
      Color priorityColor = PriorityHelper.getPriorityColor(priorityValue);

      items.add(Container(
        height: 60.0,
        child: FlatButton(
          color: priorityColor,
          child: priority == priorityValue ? Icon(Icons.check) : null,
          onPressed: () {
            setState(() {
              priority = priorityValue;
            });

            widget.setPriority(priority);
          },
        ),
      ));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItems();
  }
}
