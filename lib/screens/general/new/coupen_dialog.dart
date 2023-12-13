import 'package:flutter/material.dart';

import '../../../components/action_button.dart';
import '../../../utils/constants/styles.dart';

class CouplenDialog extends StatelessWidget {
  final String? text;

  final Function? onPressed;

  CouplenDialog({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text!,
              textAlign: TextAlign.center,
              style: kTitleTextStyle,
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ActionButton(
                        buttonText: 'Confirm', onPressed: onPressed!()),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
