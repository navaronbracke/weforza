import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// This widget represents a checkmark inside a circle.
/// The circle animates growing to a maximum size.
///
/// This widget will start the animation of its [controller],
/// if it has not already started.
class AnimatedCircleCheckmark extends StatefulWidget {
  const AnimatedCircleCheckmark({
    required this.controller,
    super.key,
  });

  /// The animation controller that drives the checkmark animation.
  final AnimationController controller;

  /// The default duration for the checkmark animation duration.
  static const Duration kCheckmarkAnimationDuration = Duration(
    milliseconds: 300,
  );

  @override
  State<AnimatedCircleCheckmark> createState() => _AnimatedCircleCheckmarkState();
}

class _AnimatedCircleCheckmarkState extends State<AnimatedCircleCheckmark> {
  Widget _buildAnimation(Color backgroundColor, IconData checkmarkIcon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double checkmarkCircleSize = max(
          constraints.biggest.shortestSide * 0.3,
          240,
        );

        return ScaleTransition(
          scale: widget.controller,
          child: Container(
            width: checkmarkCircleSize,
            height: checkmarkCircleSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(checkmarkCircleSize / 2),
              ),
              color: backgroundColor,
            ),
            child: Center(
              child: Icon(
                checkmarkIcon,
                color: Colors.white,
                size: checkmarkCircleSize * 0.7,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller.status == AnimationStatus.dismissed) {
      widget.controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData checkmarkIcon;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        backgroundColor = Theme.of(context).primaryColor;
        checkmarkIcon = Icons.check_rounded;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        backgroundColor = CupertinoTheme.of(context).primaryColor;
        checkmarkIcon = CupertinoIcons.checkmark_alt;
        break;
    }

    return Center(
      child: AnimatedBuilder(
        animation: widget.controller.drive(
          CurveTween(curve: Curves.easeOutQuart),
        ),
        builder: (context, child) => _buildAnimation(
          backgroundColor,
          checkmarkIcon,
        ),
      ),
    );
  }
}
