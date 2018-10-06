import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final bool selected;
  final Function toggle;

  ToggleButton(this.selected, this.toggle);

  @override
  State<StatefulWidget> createState() {
    return _ToggleButtonState();
  }
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _selected = false;

  @override
  void initState() {
    _selected = widget.selected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: FlatButton(
        color: Colors.blue,
        child:
            _selected ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank),
        onPressed: () {
          setState(() {
            _selected = !_selected;

            widget.toggle(_selected);
          });
        },
      ),
    );
  }
}
