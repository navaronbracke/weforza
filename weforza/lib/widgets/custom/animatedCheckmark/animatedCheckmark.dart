import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/animatedPathPainter/animatedPathPainter.dart';

class AnimatedCheckmark extends StatefulWidget {
  AnimatedCheckmark({
    @required this.duration,
    @required this.color,
    @required this.strokeWidth,
    @required this.strokeCap,
    @required this.strokeJoin,
    @required this.size,
    @required this.createPath,
  }): assert(
    duration != null && color != null && strokeWidth != null && size != null
        && strokeWidth > 0.0 && strokeCap != null
        && strokeJoin != null && createPath != null
  );

  final Duration duration;
  final Color color;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final StrokeJoin strokeJoin;
  final Size size;
  final Path Function(Size size) createPath;

  @override
  _AnimatedCheckmarkState createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: widget.size,
    painter: AnimatedPathPainter(
      animation: _animation,
      color: widget.color,
      strokeJoin: widget.strokeJoin,
      strokeWidth: widget.strokeWidth,
      strokeCap: widget.strokeCap,
      createPath: widget.createPath
    ),
  );
}

