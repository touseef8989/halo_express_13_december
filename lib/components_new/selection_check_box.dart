import 'package:flutter/material.dart';

import '../utils/constants/fonts.dart';
import 'custom_check_box.dart';

class SelectionCheckBox extends StatelessWidget {
  SelectionCheckBox({
    this.onPressed,
    this.isSelected,
    this.label,
  });
  final Function? onPressed;
  final bool? isSelected;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed!(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 45.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label!,
              textAlign: TextAlign.center,
              // ignore: prefer_const_constructors
              style: TextStyle(
                fontFamily: poppinsRegular,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            CustomCheckBox(
              isChecked: isSelected,
            ),
          ],
        ),
      ),
    );
  }
}
