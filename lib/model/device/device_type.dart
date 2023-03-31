import 'package:flutter/material.dart' show Icons, IconData;
import 'package:weforza/generated/l10n.dart';

/// This enum declares the different device types.
enum DeviceType {
  unknown(0), // This value should always be the first in the list.
  cadenceMeter(3),
  gps(5),
  headset(6),
  phone(7),
  powerMeter(2),
  pulseMonitor(1),
  watch(4);

  const DeviceType(this.typeIndex);

  /// Create a device type fron the given [typeIndex].
  factory DeviceType.fromTypeIndex(int typeIndex) {
    switch (typeIndex) {
      case 1:
        return pulseMonitor;
      case 2:
        return powerMeter;
      case 3:
        return cadenceMeter;
      case 4:
        return watch;
      case 5:
        return gps;
      case 6:
        return headset;
      case 7:
        return phone;
      default:
        return unknown;
    }
  }

  /// The serializable type index of this enum value.
  final int typeIndex;

  IconData get icon {
    switch (this) {
      case DeviceType.cadenceMeter:
        return Icons.rotate_left;
      case DeviceType.gps:
        return Icons.gps_fixed;
      case DeviceType.headset:
        return Icons.headset;
      case DeviceType.phone:
        return Icons.smartphone;
      case DeviceType.powerMeter:
        return Icons.flash_on;
      case DeviceType.pulseMonitor:
        return Icons.favorite_border;
      case DeviceType.watch:
        return Icons.watch;
      default:
        return Icons.device_unknown;
    }
  }

  String getLabel(S translator) {
    switch (this) {
      case DeviceType.cadenceMeter:
        return translator.DeviceCadenceMeter;
      case DeviceType.gps:
        return translator.DeviceGPS;
      case DeviceType.headset:
        return translator.DeviceHeadset;
      case DeviceType.phone:
        return translator.DevicePhone;
      case DeviceType.powerMeter:
        return translator.DevicePowerMeter;
      case DeviceType.pulseMonitor:
        return translator.DevicePulseMonitor;
      case DeviceType.watch:
        return translator.DeviceWatch;
      default:
        return translator.DeviceUnknown;
    }
  }
}
