import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/widgets/custom/rectangleAndCircleQuarter/rectangleAndCircleQuarter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ManualSelectionItemCounter extends StatelessWidget {
  ManualSelectionItemCounter({
    required this.backgroundColor,
    required this.countStream,
    required this.initialData,
  });

  final Color backgroundColor;
  final Stream<int> countStream;
  final int initialData;

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      children: [
        _buildBackground(),
        _buildPositioned(_buildRow()),
      ],
    );

    return _buildSizedBox(child);
  }

  Widget _buildBackground() {
    return PlatformAwareWidget(
      android: () => RectangleAndCircleQuarter(
        color: backgroundColor,
        size: Size(95, 40),
      ),
      ios: () => RectangleAndCircleQuarter(
        color: backgroundColor,
        size: Size(110, 48),
        drawHalfCircle: true,
      ),
    );
  }

  Widget _buildIcon() {
    return PlatformAwareWidget(
      android: () => Icon(
        Icons.people,
        color: Colors.white,
        size: 30,
      ),
      ios: () => Icon(
        CupertinoIcons.person_2_fill,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildSizedBox(Widget child) {
    return PlatformAwareWidget(
      android: () => SizedBox(
        width: 95,
        height: 40,
        child: child,
      ),
      ios: () => SizedBox(
        width: 110,
        height: 48,
        child: child,
      ),
    );
  }

  Widget _buildPositioned(Widget child) {
    return PlatformAwareWidget(
      android: () => Positioned(
        top: 5,
        left: 10,
        child: child,
      ),
      ios: () => Positioned(
        top: 8,
        left: 10,
        child: child,
      ),
    );
  }

  Widget _buildValue(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: StreamBuilder<int>(
            initialData: initialData,
            stream: countStream,
            builder: (context, snapshot) {
              final count = snapshot.data;
              if (snapshot.hasError || count == null) {
                return _buildValue("-");
              }

              // Limit the maximum shown number.
              // This is an edge case for overflow.
              if (count > 999) {
                return _buildValue("999+");
              }

              return _buildValue("${snapshot.data}");
            },
          ),
        ),
      ],
    );
  }
}