import 'dart:ui';

import 'package:flutter/widgets.dart';

class AnimatedPathPainter extends CustomPainter {
  AnimatedPathPainter({
    @required this.animation,
    @required this.color,
    @required this.strokeWidth,
    @required this.strokeJoin,
    @required this.strokeCap,
    @required this.createPath,
  }): assert(createPath != null && animation != null && color != null
      && strokeWidth != null && strokeWidth > 0.0 && strokeCap != null
      && strokeJoin != null), super(repaint: animation);

  final Path Function(Size size) createPath;
  final Animation<double> animation;
  final Color color;
  final StrokeJoin strokeJoin;
  final StrokeCap strokeCap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createAnimatedPath(createPath(size), animation.value);

    final Paint paint = Paint();
    paint.color = color;
    paint.strokeJoin = strokeJoin;
    paint.strokeCap = strokeCap;
    paint.strokeWidth = strokeWidth;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(AnimatedPathPainter old){
    return animation.value != old.animation.value || color != old.color ||
        strokeWidth != old.strokeWidth ||
        strokeCap != old.strokeCap || strokeJoin != old.strokeJoin;
  }

  Path _extractPathUntilLength(Path originalPath, double length) {
    final path = Path();
    final metricsIterator = originalPath.computeMetrics().iterator;
    double currentLength = 0.0;

    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      final nextLength = currentLength + metric.length;

      if (nextLength > length) {
        path.addPath(metric.extractPath(0.0, length - currentLength), Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        path.addPath(metric.extractPath(0.0, metric.length), Offset.zero);
      }
      currentLength = nextLength;
    }

    return path;
  }

  Path _createAnimatedPath(Path originalPath, double animationPercent) {
    // ComputeMetrics can only be iterated once!
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    return _extractPathUntilLength(originalPath, totalLength * animationPercent);
  }
}