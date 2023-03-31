
import 'package:flutter/material.dart' show Icon, IconData, Icons, Widget;
import 'package:weforza/model/device.dart' show DeviceType;
import 'package:weforza/theme/appTheme.dart' show ApplicationTheme;

/// This utility function takes a given [DeviceType]
/// and outputs an [Icon] widget for that type.
Widget getDeviceIcon(DeviceType deviceType){
  return Icon(
    getDeviceTypeIconData(deviceType.index),
    color: ApplicationTheme.deviceIconColor,
  );
}

/// This utility function maps the [DeviceType] enum value at [index]
/// to an [IconData] instance.
IconData getDeviceTypeIconData(int index){
  switch(DeviceType.values[index]){
    case DeviceType.HEADSET: return Icons.headset;
    case DeviceType.WATCH: return Icons.watch;
    case DeviceType.POWER_METER: return Icons.flash_on;
    case DeviceType.CADENCE_METER: return Icons.rotate_left;
    case DeviceType.PHONE: return Icons.smartphone;
    case DeviceType.GPS: return Icons.gps_fixed;
    case DeviceType.PULSE_MONITOR: return Icons.favorite_border;
    default: return Icons.device_unknown;
  }
}
