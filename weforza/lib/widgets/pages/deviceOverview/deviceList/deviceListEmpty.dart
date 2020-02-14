import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';

class DeviceListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.priority_high,
          color: ApplicationTheme.deviceIconColor,
          size: MediaQuery.of(context).size.shortestSide * .2,
        ),
        SizedBox(height: 5),
        Text(S.of(context).DeviceOverviewNoDevices),
      ],
    );
  }
}
