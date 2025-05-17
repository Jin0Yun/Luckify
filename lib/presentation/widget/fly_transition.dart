import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlyTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const FlyTransition({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;
        final angle = (90 * (1 - value)) * (math.pi / 180);

        final transform =
            Matrix4.identity()
              ..setEntry(3, 2, -0.001)
              ..rotateX(angle);

        double scale = 1.0;
        if (value <= 0.5) {
          scale = value * 2;
        }

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: scale,
            child: Opacity(opacity: value, child: this.child),
          ),
        );
      },
      child: child,
    );
  }
}