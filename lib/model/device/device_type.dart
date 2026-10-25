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

  const new(this.typeIndex);

  /// Create a device type fron the given [typeIndex].
  factory fromTypeIndex(int typeIndex) => switch (typeIndex) {
    1 => pulseMonitor,
    2 => powerMeter,
    3 => cadenceMeter,
    4 => watch,
    5 => gps,
    6 => headset,
    7 => phone,
    _ => unknown,
  };

  /// The serializable type index of this enum value.
  final int typeIndex;

  IconData get icon => switch (this) {
    .cadenceMeter => Icons.rotate_left,
    .gps => Icons.gps_fixed,
    .headset => Icons.headset,
    .phone => Icons.smartphone,
    .powerMeter => Icons.flash_on,
    .pulseMonitor => Icons.favorite_border,
    .watch => Icons.watch,
    _ => Icons.device_unknown,
  };

  String getLabel(S translator) => switch (this) {
    .cadenceMeter => translator.deviceCadenceMeter,
    .gps => translator.deviceGPS,
    .headset => translator.deviceHeadset,
    .phone => translator.devicePhone,
    .powerMeter => translator.devicePowerMeter,
    .pulseMonitor => translator.devicePulseMonitor,
    .watch => translator.deviceWatch,
    _ => translator.deviceUnknown,
  };
}
