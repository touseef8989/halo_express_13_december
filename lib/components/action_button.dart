import 'package:flutter/material.dart';

import '../utils/constants/custom_colors.dart';
import '../utils/constants/fonts.dart';

class ActionButton extends StatelessWidget {
  final String? buttonText;
  final Widget? icon;
  final VoidCallback? onPressed;

  ActionButton({required this.buttonText, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.white.withOpacity(.1),
      splashColor: Colors.white.withOpacity(.2),
      onPressed: onPressed,
      color: kColorRed,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: BorderSide(color: Colors.grey[400], width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: icon,
            ),
          Text(
            buttonText!,
            style: const TextStyle(
              fontFamily: poppinsMedium,
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtonGreen extends StatelessWidget {
  final String? buttonText;
  final Widget? icon;
  final VoidCallback? onPressed;

  ActionButtonGreen({this.buttonText, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.white.withOpacity(.1),
      splashColor: Colors.white.withOpacity(.2),
      onPressed: onPressed,
      color: Colors.green,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: BorderSide(color: Colors.grey[400], width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: icon,
            ),
          Text(
            buttonText!,
            style: const TextStyle(
              fontFamily: poppinsMedium,
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionRightIconButton extends StatelessWidget {
  final String? buttonText;
  final Widget? icon;
  final VoidCallback? onPressed;

  ActionRightIconButton({this.buttonText, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.white.withOpacity(.1),
      splashColor: Colors.white.withOpacity(.2),
      onPressed: onPressed,
      color: kColorRed,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: BorderSide(color: Colors.grey[400], width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText!,
            style: const TextStyle(
              fontFamily: poppinsMedium,
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: icon,
            ),
        ],
      ),
    );
  }
}

class ActionButtonLight extends StatelessWidget {
  ActionButtonLight({this.buttonText, this.onPressed});

  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: kColorRed.withOpacity(.05),
      disabledTextColor: kColorRed.withOpacity(.3),
      textColor: kColorRed,
      highlightColor: Colors.white.withOpacity(.2),
      splashColor: kColorRed.withOpacity(.2),
      elevation: 0,
      onPressed: onPressed,
      color: const Color(0xFFFFE9E9),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: BorderSide(color: kColorRed.withOpacity(.1), width: 1),
      ),
      child: Text(
        buttonText!,
        style: const TextStyle(
          fontFamily: poppinsMedium,
          // color: kColorRed,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class ActionButtonOutline extends StatelessWidget {
  ActionButtonOutline({
    this.buttonText,
    this.textStyle,
    this.onPressed,
  });

  final String? buttonText;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      onPressed: onPressed,
      color: Colors.white,
      textColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              buttonText!,
              style: textStyle != null
                  ? textStyle
                  : const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class ActionIconButtonOutline extends StatelessWidget {
  ActionIconButtonOutline({
    this.icon,
    this.buttonText,
    this.onPressed,
  });

  final Widget? icon;
  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      onPressed: onPressed,
      color: Colors.white,
      textColor: Colors.white,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(left: 6, right: 6), child: icon),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(left: 35, right: 35),
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  buttonText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionIconButton extends StatelessWidget {
  ActionIconButton({this.buttonText, this.icon, this.onPressed});

  final Widget? icon;
  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        disabledColor: kColorRed.withOpacity(.05),
        disabledTextColor: kColorRed.withOpacity(.3),
        textColor: kColorRed,
        highlightColor: Colors.white.withOpacity(.2),
        splashColor: kColorRed.withOpacity(.2),
        elevation: 2.0,
        onPressed: onPressed,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          // side: BorderSide(color: kColorRed.withOpacity(.1), width: 1),
        ),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              icon!,
              const SizedBox(
                height: 10,
              ),
              Text(
                buttonText!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: poppinsMedium,
                  // color: kColorRed,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ));
  }
}

class ActionWithColorButton extends StatelessWidget {
  final String? buttonText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? butColor;

  ActionWithColorButton(
      {this.buttonText, this.onPressed, this.icon, this.butColor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.white.withOpacity(.1),
      splashColor: Colors.white.withOpacity(.2),
      onPressed: onPressed,
      color: butColor != null ? butColor : kColorRed,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: BorderSide(color: Colors.grey[400], width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: icon,
            ),
          Text(
            buttonText!,
            style: const TextStyle(
              fontFamily: poppinsMedium,
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionSmallButton extends StatelessWidget {
  final String? buttonText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? butColor;

  ActionSmallButton(
      {this.buttonText, this.onPressed, this.icon, this.butColor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.white.withOpacity(.1),
      splashColor: Colors.white.withOpacity(.2),
      onPressed: onPressed,
      color: butColor != null ? butColor : kColorRed,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: BorderSide(color: Colors.grey[400], width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: icon,
            ),
          Text(
            buttonText!,
            style: const TextStyle(
              fontFamily: poppinsMedium,
              color: Colors.white,
              fontSize: 10.0,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
