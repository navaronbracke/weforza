import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/custom/animated_path_painter.dart';

/// This widget represents a checkmark that animates its path being painted.
class AnimatedCheckmark extends StatefulWidget {
  const AnimatedCheckmark({
    required this.size,
    super.key,
    this.color,
    this.duration = const Duration(milliseconds: 500),
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
    this.strokeWidth = 4.0,
  }) : assert(
          strokeWidth > 0.0,
          'The stroke width should be greater than zero',
        );

  /// The color for the stroke.
  ///
  /// If this is null, the Theme's primary color is used.
  final Color? color;

  /// The duration of the animation.
  ///
  /// Defaults to 500 milliseconds.
  final Duration duration;

  /// The size of the checkmark.
  final Size size;

  /// The stroke cap for the painter.
  ///
  /// Defaults to [StrokeCap.round].
  final StrokeCap strokeCap;

  /// The width of the painter's stroke.
  ///
  /// Defaults to 4.
  final double strokeWidth;

  /// The stroke join of the painter.
  ///
  /// Defaults to [StrokeJoin.round].
  final StrokeJoin strokeJoin;

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  Path _createPath(Size size) {
    final xOffset = size.width * .1;
    final yOffset = -(size.height * .1);

    return Path()
      ..moveTo((size.width * .8) + xOffset, (size.height * .2) + yOffset)
      ..lineTo((size.width * .3) + xOffset, size.height + yOffset)
      ..lineTo(size.width * .15, (size.height * .8) + yOffset);
  }

  Color _resolveColor(BuildContext context) {
    Color? effectiveColor = widget.color;

    final theme = Theme.of(context);

    if (effectiveColor == null) {
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          effectiveColor = theme.primaryColor;
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          effectiveColor = CupertinoTheme.of(context).primaryColor;
          break;
      }
    }

    return effectiveColor;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: AnimatedPathPainter(
        animation: _animation,
        color: _resolveColor(context),
        strokeJoin: widget.strokeJoin,
        strokeWidth: widget.strokeWidth,
        strokeCap: widget.strokeCap,
        createPath: _createPath,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// This widget represents an [AnimatedCheckmark]
/// that scales itself to a [fraction] of the available layout.
class AdaptiveAnimatedCheckmark extends StatelessWidget {
  const AdaptiveAnimatedCheckmark({
    super.key,
    this.color,
    this.duration = const Duration(milliseconds: 500),
    this.fraction = 0.3,
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
    this.strokeWidth = 4.0,
  });

  /// The color for the stroke.
  ///
  /// If this is null, the Theme's primary color is used.
  final Color? color;

  /// The duration of the animation.
  ///
  /// Defaults to 500 milliseconds.
  final Duration duration;

  /// The percent of the shortest available constraint that this
  /// animated checkmark should occupy.
  ///
  /// Defaults to 30 percent.
  final double fraction;

  /// The stroke cap for the painter.
  ///
  /// Defaults to [StrokeCap.round].
  final StrokeCap strokeCap;

  /// The width of the painter's stroke.
  ///
  /// Defaults to 4.
  final double strokeWidth;

  /// The stroke join of the painter.
  ///
  /// Defaults to [StrokeJoin.round].
  final StrokeJoin strokeJoin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final paintSize = constraints.biggest.shortestSide * fraction;

          return AnimatedCheckmark(
            color: color,
            duration: duration,
            size: Size.square(paintSize),
            strokeCap: strokeCap,
            strokeJoin: strokeJoin,
            strokeWidth: strokeWidth,
          );
        },
      ),
    );
  }
}
