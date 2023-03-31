import 'package:flutter/widgets.dart';

/// A [StatelessWidget] that draws a rectangle on the left
/// and a right upper circle quarter on the right.
///
/// The given color is used as the color for the shape.
/// The given size is used as dimension for the shape.
/// The width and height of the size should be greater than zero.
/// The width should be bigger than the height.
class RectangleAndCircleQuarter extends StatelessWidget {
  final Color color;
  final Size size;

  RectangleAndCircleQuarter({
    required this.color,
    required this.size,
  }): assert(size.width > 0 && size.height > 0 && size.width > size.height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRect(
        child: CustomPaint(
          painter: _RectangleAndCircleQuarterPainter(
            color: color,
          ),
        ),
      ),
    );
  }
}

/// The internal [CustomPainter] for [RectangleAndCircleQuarter].
class _RectangleAndCircleQuarterPainter extends CustomPainter {
  final Color color;

  _RectangleAndCircleQuarterPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final rectWidth = size.width - size.height;

    // Draw a rectangle on the left
    // that fills the height
    // and the remainder of the width - the circle quarter radius.
    canvas.drawRect(Rect.fromLTWH(0, 0, rectWidth, size.height), paint);

    // Draw a circle that overlaps the entire height
    // and enough of the right side portion of the width for its radius.
    //
    // The circle's center point is located here:
    // x:  right bottom corner of the rectangle
    // y:  bottom of the canvas
    canvas.drawCircle(Offset(rectWidth, size.height), size.height, paint);
  }

  @override
  bool shouldRepaint(_RectangleAndCircleQuarterPainter oldDelegate) {
    return color == oldDelegate.color;
  }
}