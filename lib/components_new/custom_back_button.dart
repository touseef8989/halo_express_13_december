import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton({this.back});

  final VoidCallback? back;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: 20.0,
      ),
      onPressed: back != null ? back! : () => {Navigator.pop(context)},
    );
  }
}
