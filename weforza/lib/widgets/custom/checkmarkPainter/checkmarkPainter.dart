import 'dart:math';

import 'package:flutter/widgets.dart';

class CheckmarkPainter extends StatefulWidget {
  CheckmarkPainter({
    @required this.duration,
    @required this.color,
    @required this.strokeCap,
    @required this.strokeJoin,
    @required this.strokeWidth,
    @required this.size,
  }): assert(
  duration != null && color != null && strokeCap != null && strokeJoin != null
      && size != null && strokeWidth != null && strokeWidth > 0.0
  );

  final Size size;
  final Duration duration;
  final Color color;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final double strokeWidth;

  @override
  _CheckmarkPainterState createState() => _CheckmarkPainterState();
}

class _CheckmarkPainterState extends State<CheckmarkPainter> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  Map<String,dynamic> _drawData;

  @override
  void initState() {
    super.initState();
    _drawData = _calculateCheckmarkPointsAndAnimationShare(widget.size);
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => CustomPaint(
        painter: _CheckmarkPainter(
            color: widget.color,
            progress: _animation.value,
            strokeCap: widget.strokeCap,
            strokeWidth: widget.strokeWidth,
            strokeJoin: widget.strokeJoin,
            drawData: _drawData
        ),
      ),
    );
  }

  //Calculate the checkmark points and line animation share in advance
  Map<String,dynamic> _calculateCheckmarkPointsAndAnimationShare(Size size){
    //These are the checkmark path points
    final p1 = Offset(size.width / 3,size.height * 3 / 4);
    final p2 = Offset(size.width / 2,size.height * 5 / 6);
    final p3 = Offset(size.width * 3 / 4,size.height * 4 / 6);

    //Get the length of each line
    final distanceP1P2 = sqrt(pow((p2.dx - p1.dx), 2) + pow(p2.dy - p1.dy,2));
    final distanceP2P3 = sqrt(pow((p2.dx - p3.dx), 2) + pow(p2.dy - p3.dy,2));

    final result = {
      "p1": p1,
      "p2": p2,
      "p3": p3,
      //calculate the animation share for line 1
      //= line 1 length / length of line 1 + 2.
      //We don't need this for line 2 since we switch from line 1 to 2 when drawing.
      //Round it off to get a prettier value.
      "firstLineDrawingThreshold": (distanceP1P2 / (distanceP1P2 + distanceP2P3))
    };

    return result;
  }
}

class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({
    @required this.color,
    @required this.strokeCap,
    @required this.strokeJoin,
    @required this.strokeWidth,
    @required this.progress,
    @required this.drawData,
  }): assert(
  color != null && strokeCap != null && strokeJoin != null && drawData != null
      && strokeWidth != null && strokeWidth > 0.0
      && progress >= 0.0 && progress <= 1.0
  );

  final Color color;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final double strokeWidth;
  final double progress;
  final Map<String,dynamic> drawData;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    paint.strokeWidth = strokeWidth;
    paint.strokeJoin = strokeJoin;
    paint.strokeCap = strokeCap;

    final firstLineDrawingThreshold = drawData["firstLineDrawingThreshold"];

    //While the progress hasn't reached the drawing threshold for line 1
    //keep drawing line 1.
    if(progress < firstLineDrawingThreshold){
      //Draw the first line only, using the normalized animation progress.
      //The animation itself goes from 0.0 -> 1.0.
      //However the duration for drawing a line is proportional to its length.
      //Hence why we divide the current progress by it's relative share of the total animation progress.
      //This share is equal to the value of firstLineDrawingThreshold.
      //The result of this division turns 0 - firstLineDrawingThreshold
      //into a 0 - 1 range.
      //When it hits 1, the line is fully drawn
      //and the animation already progressed firstLineDrawingThreshold towards 1.0.
      final actualProgress = progress / firstLineDrawingThreshold;
      canvas.drawLine(drawData["p3"], Offset(drawData["p2"].dx * actualProgress, drawData["p2"].dy * actualProgress), paint);
    }else{
      //draw the first line again (now it is fully drawn)
      canvas.drawLine(drawData["p3"], drawData["p2"], paint);
      //Draw the second line, using the normalized animation progress.
      //Since the animation has already progressed firstLineDrawingThreshold towards 1.0,
      //we need to get whats left and use that to draw the second line.
      final actualProgress = progress / (1.0 - firstLineDrawingThreshold);
      canvas.drawLine(drawData["p2"], Offset(drawData["p1"].dx * actualProgress, drawData["p1"].dy * actualProgress), paint);
    }
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate)
  => progress != oldDelegate.progress || color != oldDelegate.color;
}
