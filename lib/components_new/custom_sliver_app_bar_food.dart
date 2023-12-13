import 'package:flutter/material.dart';

import '../utils/constants/styles.dart';

class CustomSliverAppBarFoodDelegate extends SliverPersistentHeaderDelegate {
  final double? expandedHeight;
  final double? topSafeArea;
  final Widget? topChild;
  final Widget? botChild;

  const CustomSliverAppBarFoodDelegate({
    this.expandedHeight,
    this.topSafeArea,
    this.topChild,
    this.botChild,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: kAppBarGradient,
        ),
        Positioned(
          top: 230,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.white,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          bottom: 0,
          left: 0,
          right: 0,
          child: topChild!,
        ),
        Positioned(
          top: expandedHeight! - 230 - shrinkOffset,
          bottom: 0,
          left: 0,
          right: 0,
          child: Opacity(opacity: disappear(shrinkOffset), child: botChild),
        ),
      ],
    );
  }

  double getTotalHeightToShinrk() {
    return expandedHeight! - (kToolbarHeight + topSafeArea!);
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight!;

  double disappear(double shrinkOffset) =>
      (1 - shrinkOffset / expandedHeight!) < 0.0
          ? 0.0
          : (1 - shrinkOffset / expandedHeight!);

  @override
  double get maxExtent => expandedHeight! + 12;

  @override
  double get minExtent => kToolbarHeight + topSafeArea!;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
