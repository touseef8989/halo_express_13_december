import 'package:flutter/material.dart';

class ShadowCard extends StatelessWidget {
  ShadowCard({
    this.child,
    this.showShadow = true,
  });

  final Widget? child;
  final bool? showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: showShadow!
          ? BoxDecoration(
              // color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 10.0, // has the effect of softening the shadow
                  offset: const Offset(
                    0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            )
          : null,
      child: Material(
        color: Colors.grey[100],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: child,
        ),
      ),
    );
  }
}
