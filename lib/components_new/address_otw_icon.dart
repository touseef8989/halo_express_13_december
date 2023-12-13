import 'package:flutter/material.dart';

class AddressOTWIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
