import 'package:flutter/material.dart';

import '../utils/constants/custom_colors.dart';
import '../utils/constants/fonts.dart';

class ProfileOption extends StatelessWidget {
  ProfileOption({
    this.icon,
    this.label,
    this.onPressed,
  });

  final String? icon;
  final String? label;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed!(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: lightGrey,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              child: Image.asset(
                icon!,
                width: 25,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label!,
              style: const TextStyle(fontFamily: poppinsSemiBold, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
