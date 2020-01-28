import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

class RideAttendeeCounter extends StatelessWidget {
  RideAttendeeCounter(this.count): assert(count != null);

  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(count),
        SizedBox(width: 5),
        Icon(Icons.people,color: ApplicationTheme.rideAttendeeCounterIconColor),
      ],
    );
  }
}
