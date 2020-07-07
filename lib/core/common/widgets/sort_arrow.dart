import 'dart:math' as math;

import 'package:flutter/material.dart';

class SortArrow extends StatelessWidget {
  const SortArrow({
    this.down,
    this.color,
  });

  static const double _arrowIconSize = 16.0;

  final bool down;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationZ(down ? 0.0 : math.pi),
      alignment: Alignment.center,
      child: Icon(
        Icons.arrow_downward,
        size: _arrowIconSize,
        color: color ??
            ((Theme.of(context).brightness == Brightness.light)
                ? Colors.black87
                : Colors.white70),
      ),
    );
  }
}
