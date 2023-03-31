import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

///This widget is shown as replacement of a [Member]'s devices, if it has none.
class MemberDevicesListEmpty extends StatelessWidget {
  const MemberDevicesListEmpty({
    Key? key,
    required this.onAddDevicePageButtonPressed,
  }) : super(key: key);

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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Text(
                S.of(context).MemberDetailsNoDevices,
                textAlign: TextAlign.center,
              ),
            ),
            PlatformAwareWidget(
              android: () => ElevatedButton(
                onPressed: onAddDevicePageButtonPressed,
                child: Text(S.of(context).AddDeviceTitle),
              ),
              ios: () => CupertinoButton.filled(
                onPressed: onAddDevicePageButtonPressed,
                child: Text(
                  S.of(context).AddDeviceTitle,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      );
}
