import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RiderDevicesListHeader extends StatelessWidget {
  const RiderDevicesListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final title = S.of(context).devices;

    return PlatformAwareWidget(
      android: (context) {
        final textTheme = Theme.of(context).textTheme;

        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      },
      ios: (context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          title,
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
      ),
    );
  }
}
