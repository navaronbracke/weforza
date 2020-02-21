import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

class RideAttendeeCounter extends StatelessWidget {
  RideAttendeeCounter({this.count,this.iconSize,this.counterStyle}): assert(count != null);

  final double iconSize;
  final TextStyle counterStyle;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        counterStyle == null ? Text(count): Text(count,style: counterStyle),
        SizedBox(width: 5),
        Icon(Icons.people,size: iconSize ?? 24,color: ApplicationTheme.rideAttendeeCounterIconColor),
      ],
    );
  }
}
