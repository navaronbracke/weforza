import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevicesListHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        S.of(context).Devices,
        style: ApplicationTheme.memberDevicesListHeaderTextStyle,
      ),
    ),
    ios: () => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        S.of(context).Devices,
        style: ApplicationTheme.memberDevicesListHeaderTextStyle,
      ),
    ),
  );
}
