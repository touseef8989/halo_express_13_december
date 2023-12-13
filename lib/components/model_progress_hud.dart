import 'package:flutter/material.dart';

import 'halo_loading.dart';

class ModalProgressHUD extends StatelessWidget {
  final bool? inAsyncCall;
  final double? opacity;
  final Color? color;
  final Widget? progressIndicator;
  final Offset? offset;
  final bool? dismissible;
  final Widget? child;

  ModalProgressHUD({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.1,
    this.color = Colors.red,
    this.progressIndicator = const HaloLoading(),
    this.offset,
    this.dismissible = false,
    required this.child,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child!);
    if (inAsyncCall!) {
      Widget layOutProgressIndicator;
      if (offset == null) {
        layOutProgressIndicator = Center(child: progressIndicator);
      } else {
        layOutProgressIndicator = Positioned(
          left: offset!.dx,
          top: offset!.dy,
          child: progressIndicator!,
        );
      }
      final modal = [
        Opacity(
          opacity: opacity!,
          child: ModalBarrier(dismissible: dismissible!, color: color),
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return Stack(
      children: widgetList,
    );
  }
}
