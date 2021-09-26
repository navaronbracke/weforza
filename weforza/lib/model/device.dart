
import 'dart:ui';

import 'package:weforza/cipher/cipher.dart';

///A device is a piece of hardware.
///It has a [name], an [ownerId] and a [type].
class Device {
  Device({
    required this.ownerId,
    required this.name,
    required this.creationDate,
    this.type = DeviceType.UNKNOWN
  }): assert(ownerId.isNotEmpty && name.isNotEmpty);

  final String ownerId;
  final DateTime creationDate;
  final String name;
  final DeviceType type;

  static final RegExp deviceNameRegex = RegExp(r"^[^,]{1,40}$");

  /// Convert this object to a Map, encrypting sensitive values.
  Map<String,dynamic> encrypt(Cipher cipher){
    return {
      "deviceName": cipher.encrypt(name),
      "owner": ownerId,
      "type": type.index
    };
  }

  /// Create a device from a Map and a given key,
  /// while decrypting sensitive values with the [Cipher].
  static Device decrypt(String key, Map<String, dynamic> values, Cipher cipher){
    assert(key.isNotEmpty);
    //Start with unknown
    DeviceType type = DeviceType.UNKNOWN;
    //if the index fits within the values, use it
    if(values["type"] < DeviceType.values.length){
      type = DeviceType.values[values["type"]];
    }

    return Device(
      creationDate: DateTime.parse(key),
      name: cipher.decrypt(values["deviceName"]),
      ownerId: values["owner"],
      type: type
    );
  }

  @override
  bool operator ==(Object other) => other is Device && name == other.name
      && ownerId == other.ownerId;

  @override
  int get hashCode => hashValues(name, ownerId);
}

///This enum declares the different device types.
///[DeviceType.UNKNOWN] This is the default for when the type is unknown or not specified here.
///[DeviceType.PHONE] The device is a phone.
///[DeviceType.POWER_METER] The device is a power meter.
///[DeviceType.CADENCE_METER] The device is a cadence meter.
///[DeviceType.WATCH] The device is a (smart)watch that supports bluetooth.
///[DeviceType.HEADSET] The device is a wireless headset/a pair of wireless earbuds.
///[DeviceType.GPS] The device is a GPS.
///[DeviceType.PULSE_MONITOR] The device is a heart rate monitor.
enum DeviceType {
  UNKNOWN,
  PULSE_MONITOR,
  POWER_METER,//powermeter
  CADENCE_METER,//cadence meter
  WATCH,//smartwatch
  GPS,
  HEADSET,
  PHONE,//smartphone
}