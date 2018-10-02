import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
  }
}
