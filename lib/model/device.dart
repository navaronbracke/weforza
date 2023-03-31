import 'dart:ui';

///A device is a piece of hardware.
///It has a [name], an [ownerId] and a [type].
class Device {
  Device(
      {required this.ownerId,
      required this.name,
      required this.creationDate,
      this.type = DeviceType.unknown})
      : assert(ownerId.isNotEmpty && name.isNotEmpty);

  final String ownerId;
  final DateTime creationDate;
  String name;
  DeviceType type;

  static final RegExp deviceNameRegex = RegExp(r'^[^,]{1,40}$');

  ///Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {'deviceName': name, 'owner': ownerId, 'type': type.index};
  }

  ///Create a device from a Map and a given key.
  static Device of(String key, Map<String, dynamic> values) {
    assert(key.isNotEmpty);
    //Start with unknown
    DeviceType type = DeviceType.unknown;
    //if the index fits within the values, use it
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
  phone,
}
