import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This widget represents a checkmark inside a circle.
/// The circle animates growing to a maximum size.
class AnimatedCircleCheckmark extends StatelessWidget {
  const AnimatedCircleCheckmark({
    required this.controller,
    super.key,
  });

  /// The animation controller that drives the checkmark animation.
  final AnimationController controller;

  Widget _buildAnimation(Color backgroundColor, IconData checkmarkIcon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double checkmarkCircleSize = max(
          constraints.biggest.shortestSide * 0.3,
          240,
        );

        return ScaleTransition(
          scale: controller,
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
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData checkmarkIcon;

    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        backgroundColor = theme.primaryColor;
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
        animation: controller,
        builder: (context, child) => _buildAnimation(
          backgroundColor,
          checkmarkIcon,
        ),
      ),
    );
  }
}
