import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class AttendeeListCounter extends StatelessWidget {
  AttendeeListCounter({
    required this.count
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    // We usually show an empty list widget in this case.
    if(count == 0){
      return SizedBox.shrink();
    }

    if(count == 1){
      return PlatformAwareWidget(
        android: () => Text(
          S.of(context).AttendeeCounterOne,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        ios: () => Text(
          S.of(context).AttendeeCounterOne,
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    return PlatformAwareWidget(
      android: () => Text(
        S.of(context).AttendeeCounterMany(count),
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
      ios: () => Text(
        S.of(context).AttendeeCounterMany(count),
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}