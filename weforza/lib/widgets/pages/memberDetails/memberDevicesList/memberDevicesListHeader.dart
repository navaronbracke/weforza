import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevicesListHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Text(
        S.of(context).Devices,
        style: ApplicationTheme.memberDevicesListHeaderTextStyle,
      ),
    ),
    ios: () => Padding(
      padding: const EdgeInsets.fromLTRB(10,15,15,10),
      child: Text(
        S.of(context).Devices,
        style: ApplicationTheme.memberDevicesListHeaderTextStyle,
      ),
    ),
  );
}
