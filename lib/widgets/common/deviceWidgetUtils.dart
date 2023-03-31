import 'package:flutter/material.dart' show Icon, IconData, Icons, Widget;
import 'package:weforza/model/device.dart' show DeviceType;
import 'package:weforza/theme/appTheme.dart' show ApplicationTheme;

/// This utility function takes a given [DeviceType]
/// and outputs an [Icon] widget for that type.
Widget getDeviceIcon(DeviceType deviceType) {
  return Icon(
    getDeviceTypeIconData(deviceType.index),
    color: ApplicationTheme.deviceIconColor,
  );
}

/// This utility function maps the [DeviceType] enum value at [index]
/// to an [IconData] instance.
IconData getDeviceTypeIconData(int index) {
  switch (DeviceType.values[index]) {
    case DeviceType.headset:
      return Icons.headset;
    case DeviceType.watch:
      return Icons.watch;
    case DeviceType.powerMeter:
      return Icons.flash_on;
    case DeviceType.cadenceMeter:
      return Icons.rotate_left;
    case DeviceType.phone:
      return Icons.smartphone;
    case DeviceType.gps:
      return Icons.gps_fixed;
    case DeviceType.pulseMonitor:
      return Icons.favorite_border;
    default:
      return Icons.device_unknown;
  }
}
