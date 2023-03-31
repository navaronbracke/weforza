import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/animated_path_painter.dart';

class AnimatedCheckmark extends StatefulWidget {
  const AnimatedCheckmark({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    required this.color,
    this.strokeWidth = 4.0,
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
    required this.size,
  })  : assert(strokeWidth > 0.0),
        super(key: key);

  final Duration duration;
  final Color color;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final StrokeJoin strokeJoin;
  final Size size;

  @override
  _AnimatedCheckmarkState createState() => _AnimatedCheckmarkState();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: AnimatedPathPainter(
        animation: _animation,
        color: widget.color,
        strokeJoin: widget.strokeJoin,
        strokeWidth: widget.strokeWidth,
        strokeCap: widget.strokeCap,
        createPath: _createPath,
      ),
    );
  }

  Path _createPath(Size size) {
    final xOffset = size.width * .1;
    final yOffset = -(size.height * .1);

    return Path()
      ..moveTo((size.width * .8) + xOffset, (size.height * .2) + yOffset)
      ..lineTo((size.width * .3) + xOffset, size.height + yOffset)
      ..lineTo(xOffset, (size.height * .8) + yOffset);
  }
}
