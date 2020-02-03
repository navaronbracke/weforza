import 'dart:ui';

import 'package:flutter/foundation.dart';

///A device is a piece of hardware.
///It has a [name], an [ownerId] and a [type].
class Device {
  Device({
    @required this.ownerId,
    @required this.name,
    this.type = DeviceType.UNKNOWN
  }): assert(ownerId != null && ownerId.isNotEmpty && name != null
      && name.isNotEmpty && type != null);

  final String ownerId;
  String name;
  DeviceType type;

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "owner": ownerId,
      "type": type.index
    };
  }

  ///Create a device from a Map and a given key.
  static Device of(String deviceName,Map<String,dynamic> values){
    assert(deviceName != null && deviceName.isNotEmpty && values != null);
    return Device(
      name: deviceName,
      ownerId: values["owner"],
      type: DeviceType.values[values["type"]]
    );
  }

  @override
  bool operator ==(Object other) => other is Device && ownerId == other.ownerId
      && name == other.name && type == other.type;

  @override
  int get hashCode => hashValues(ownerId,name,type);
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