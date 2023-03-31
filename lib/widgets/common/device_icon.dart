import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/device/device_type.dart';

class DeviceIcon extends StatelessWidget {
  const DeviceIcon({
    required this.type,
    super.key,
    this.size,
  });

  final double? size;

  final DeviceType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icon(type.icon, color: theme.primaryColor, size: size);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icon(
          type.icon,
          color: CupertinoTheme.of(context).primaryColor,
          size: size,
        );
    }
  }
}
