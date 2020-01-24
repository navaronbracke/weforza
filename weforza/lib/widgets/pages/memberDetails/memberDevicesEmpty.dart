import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';

///This widget is shown as replacement of a [Member]'s devices, if it has none.
class MemberDevicesEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.devices_other),
        Text(S.of(context).MemberDetailsNoDevices),
      ],
    );
  }
}
