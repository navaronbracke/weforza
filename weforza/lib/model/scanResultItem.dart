
import 'package:flutter/foundation.dart';
import 'package:weforza/model/member.dart';

///This class represents a bluetooth scan result.
///The [findDeviceOwners] future will look for the [Member]s that own a device with the given name.
class ScanResultItem {
  ScanResultItem({
    @required this.deviceName,
    @required this.findDeviceOwners
  }): assert(deviceName != null && deviceName.isNotEmpty && findDeviceOwners != null);

  final Future<List<Member>> findDeviceOwners;
  final String deviceName;
}