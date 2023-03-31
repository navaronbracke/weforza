import 'dart:ui';

import 'package:flutter/foundation.dart';

///A device is a piece of hardware.
///It has a [name], an [ownerId] and a [type].
class Device {
  Device({
    @required this.ownerId,
    @required this.name,
    @required this.creationDate,
    this.type = DeviceType.UNKNOWN
  }): assert(ownerId != null && ownerId.isNotEmpty && name != null
      && name.isNotEmpty && type != null && creationDate != null);

  final String ownerId;
  final DateTime creationDate;
  String name;
  DeviceType type;

  static final RegExp deviceNameRegex = RegExp(r"^[^,]{1,40}$");

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "deviceName": name,
      "owner": ownerId,
      "type": type.index
    };
  }

  ///Create a device from a Map and a given key.
  static Device of(String key, Map<String,dynamic> values){
    assert(values != null &&  key != null && key.isNotEmpty);
    return Device(
      creationDate: DateTime.parse(key),
      name: values["deviceName"],
      ownerId: values["owner"],
      type: DeviceType.values[values["type"]]
    );
  }

  @override
  bool operator ==(Object other) => other is Device && ownerId == other.ownerId
      && name == other.name && type == other.type && creationDate == other.creationDate;

  @override
  int get hashCode => hashValues(ownerId,name,type,creationDate);
}

///This enum declares the different device types.
///[DeviceType.UNKNOWN] This is the default for when the type is unknown or not specified here.
///[DeviceType.PHONE] The device is a phone.
///[DeviceType.TABLET] The device is a tablet.
///[DeviceType.WATCH] The device is a (smart)watch that supports bluetooth.
///[DeviceType.HEADSET] The device is a wireless headset/a pair of wireless earbuds.
///[DeviceType.GPS] The device is a GPS.
///[DeviceType.PULSE_MONITOR] The device is a heart rate monitor.
enum DeviceType {
  UNKNOWN,//device unknown
  PHONE,//smartphone
  WATCH,//watch
  TABLET,//tablet
  HEADSET,//headset
  GPS,//gps_fixed
  PULSE_MONITOR//favorite border
}