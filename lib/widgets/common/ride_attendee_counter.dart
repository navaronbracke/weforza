import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideAttendeeCounter extends StatelessWidget {
  const RideAttendeeCounter({
    Key? key,
    required this.future,
    this.iconSize = 24,
    this.counterStyle,
  }) : super(key: key);

  final double iconSize;
  final TextStyle? counterStyle;
  final Future<int> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Row(
              children: [
                Text(
                  snapshot.hasError ? '?' : '${snapshot.data}',
                  style: counterStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: PlatformAwareWidget(
                    android: () => Icon(
                      Icons.people,
                      size: iconSize,
                      color: counterStyle?.color,
                    ),
                    ios: () => Icon(
                      CupertinoIcons.person_2_fill,
                      size: iconSize,
                      color: counterStyle?.color,
                    ),
                  ),
                ),
              ],
            );
          default:
            return SizedBox.square(
              dimension: iconSize,
              child: Center(
                child: PlatformAwareWidget(
                  android: () => SizedBox.square(
                    dimension: iconSize * .8,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  ios: () => const CupertinoActivityIndicator(radius: 8),
                ),
              ),
            );
        }
      },
    );
  }
}
