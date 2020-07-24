
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:weforza/model/member.dart';

///This class represents a bluetooth scan result.
///The [memberLookup] property is a future that will look for the member.
///If it is found, the list item of this object updates itself to show the name of the person.
///If it is not found an error icon is shown next to the 'deviceName'.
class ScanResultItem {
  ScanResultItem({
    @required this.deviceName,
    @required this.memberLookup
  }): assert(deviceName != null && deviceName.isNotEmpty && memberLookup != null);

  final Future<Member> memberLookup;
  final String deviceName;

  @override
  operator ==(other) => other is ScanResultItem && 
    deviceName == other.deviceName && memberLookup == other.memberLookup;

  @override
  int get hashCode => hashValues(deviceName, memberLookup);

}