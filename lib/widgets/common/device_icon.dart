import 'package:flutter/material.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/widgets/theme.dart';

class DeviceIcon extends StatelessWidget {
  const DeviceIcon({super.key, this.size, required this.type});

  final double? size;

  final DeviceType type;

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icon(
          type.icon,
          color: AppTheme.deviceTypePicker.android.selectedColor,
          size: size,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icon(
          type.icon,
          color: AppTheme.deviceTypePicker.ios.selectedColor,
          size: size,
        );
    }
  }
}
