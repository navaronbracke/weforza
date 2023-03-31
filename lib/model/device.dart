import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';

///A device is a piece of hardware.
///It has a [name], an [ownerId] and a [type].
class Device {
  Device({
    required this.ownerId,
    required this.name,
    required this.creationDate,
    this.type = DeviceType.unknown,
  }) : assert(ownerId.isNotEmpty && name.isNotEmpty);

  final String ownerId;
  final DateTime creationDate;
  String name;
  DeviceType type;

  static const int nameMaxLength = 40;

  ///Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {'deviceName': name, 'owner': ownerId, 'type': type.index};
  }

  ///Create a device from a Map and a given key.
  static Device of(String key, Map<String, dynamic> values) {
    assert(key.isNotEmpty);

    DeviceType type = DeviceType.unknown;

    if (values['type'] < DeviceType.values.length) {
      type = DeviceType.values[values['type']];
    }

    return Device(
        creationDate: DateTime.parse(key),
        name: values['deviceName'],
        ownerId: values['owner'],
        type: type);
  }

  @override
  bool operator ==(Object other) =>
      other is Device && name == other.name && ownerId == other.ownerId;

  @override
  int get hashCode => hashValues(name, ownerId);
}

/// This enum declares the different device types.
/// [DeviceType.phone] The device is a phone.
/// [DeviceType.powerMeter] The device is a power meter.
/// [DeviceType.cadenceMeter] The device is a cadence meter.
/// [DeviceType.watch] The device is a (smart)watch that supports bluetooth.
/// [DeviceType.headset] The device is a wireless headset /
/// a pair of wireless earbuds.
/// [DeviceType.gps] The device is a GPS.
/// [DeviceType.pulseMonitor] The device is a heart rate monitor.
enum DeviceType {
  unknown,
  pulseMonitor,
  powerMeter,
  cadenceMeter,
  watch,
  gps,
  headset,
  phone;

  IconData get icon {
    switch (this) {
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

  String getLabel(S translator) {
    switch (this) {
      case DeviceType.headset:
        return translator.DeviceHeadset;
      case DeviceType.watch:
        return translator.DeviceWatch;
      case DeviceType.powerMeter:
        return translator.DevicePowerMeter;
      case DeviceType.cadenceMeter:
        return translator.DeviceCadenceMeter;
      case DeviceType.phone:
        return translator.DevicePhone;
      case DeviceType.gps:
        return translator.DeviceGPS;
      case DeviceType.pulseMonitor:
        return translator.DevicePulseMonitor;
      default:
        return translator.DeviceUnknown;
    }
  }
}
