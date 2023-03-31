import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget is shown as replacement of a [Member]'s devices, if it has none.
class MemberDevicesListEmpty extends StatelessWidget {
  MemberDevicesListEmpty({
    required this.onAddDevicePageButtonPressed
  });

  final void Function() onAddDevicePageButtonPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlatformAwareWidget(
          android: () => Icon(
            Icons.devices_other,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          ios: () => Icon(
            Icons.devices_other,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(S.of(context).MemberDetailsNoDevices),
        ),
        PlatformAwareWidget(
          android: () => TextButton(
            onPressed: onAddDevicePageButtonPressed,
            child: Text(S.of(context).AddDeviceTitle),
          ),
          ios: () => CupertinoButton(
            onPressed: onAddDevicePageButtonPressed,
            child: Text(
                S.of(context).AddDeviceTitle,
                style: ApplicationTheme.iosButtonTextStyle,
            ),
          ),
        )
      ],
    ),
  );
}
