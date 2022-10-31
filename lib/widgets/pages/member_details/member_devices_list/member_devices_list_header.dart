import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

class MemberDevicesListHeader extends StatelessWidget {
  const MemberDevicesListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const theme = AppTheme.memberDevicesList;
    final child = Text(S.of(context).Devices, style: theme.headerStyle);

    return PlatformAwareWidget(
      android: (_) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: child,
      ),
      ios: (_) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: child,
      ),
    );
  }
}
