import 'package:flutter/material.dart';

import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/widgets/helpers/priority_helper.dart';

class PrioritySelector extends StatefulWidget {
  final Function setPriority;
  final Priority priority;

  PrioritySelector(this.priority, this.setPriority);

  @override
  State<StatefulWidget> createState() {
    return _PrioritySelectorState();
  }
}

class _PrioritySelectorState extends State<PrioritySelector> {
  Priority _priority;

  @override
  void initState() {
    _priority = widget.priority;

    super.initState();
  }

  List<Container> _buildItems() {
    List<Container> items = new List<Container>();

    Priority.values.forEach((p) {
      Color priorityColor = PriorityHelper.getPriorityColor(p);

      items.add(Container(
        height: 60.0,
        child: FlatButton(
          color: priorityColor,
          child: _priority == p ? Icon(Icons.check) : null,
          onPressed: () {
            setState(() {
              _priority = p;
            });

            widget.setPriority(_priority);
          },
        ),
      ));
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildItems(),
    );
  }
}
