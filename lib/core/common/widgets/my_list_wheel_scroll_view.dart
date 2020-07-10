import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyListWheelScrollView extends StatelessWidget {
  final Widget Function(BuildContext, int) builder;
  final Axis scrollDirection;
  final FixedExtentScrollController controller;
  final int childCount;
  final double itemExtent;
  final double perspective;
  final double diameterRatio;
  final double offAxisFraction;
  final bool useMagnifier;
  final double magnification;
  final double overAndUnderCenterOpacity;
  final double squeeze;
  final bool renderChildrenOutsideViewport;
  final Clip clipBehavior;
  final ScrollPhysics physics;
  final void Function(int) onSelectedItemChanged;

  const MyListWheelScrollView(
      {Key key,
      this.controller,
      this.physics,
      this.scrollDirection = Axis.vertical,
      this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
      this.perspective = RenderListWheelViewport.defaultPerspective,
      this.offAxisFraction = 0.0,
      this.useMagnifier = false,
      this.magnification = 1.0,
      this.overAndUnderCenterOpacity = 1.0,
      @required this.itemExtent,
      this.squeeze = 1.0,
      this.onSelectedItemChanged,
      this.renderChildrenOutsideViewport = false,
      this.clipBehavior = Clip.hardEdge,
      @required this.childCount,
      @required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: scrollDirection == Axis.horizontal ? 3 : 0,
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: onSelectedItemChanged,
        controller: controller,
        diameterRatio: diameterRatio,
        physics: physics,
        perspective: perspective,
        offAxisFraction: offAxisFraction,
        useMagnifier: useMagnifier,
        magnification: magnification,
        overAndUnderCenterOpacity: overAndUnderCenterOpacity,
        itemExtent: itemExtent,
        squeeze: squeeze,
        renderChildrenOutsideViewport: renderChildrenOutsideViewport,
        clipBehavior: clipBehavior,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: childCount,
          builder: (context, index) {
            return RotatedBox(
              quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
              child: builder(context, index),
            );
          },
        ),
      ),
    );
  }
}
