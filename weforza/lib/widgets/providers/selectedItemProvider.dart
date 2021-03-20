import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';

///This InheritedWidget manages the selected items for Ride and Member.
class SelectedItemProvider extends InheritedWidget {
  SelectedItemProvider({
    Key? key,
    required Widget child,
  }): super(key: key, child: child);

  final ValueNotifier<Ride?> selectedRide = ValueNotifier(null);
  final ValueNotifier<Member?> selectedMember = ValueNotifier(null);
  final ValueNotifier<Future<int>?> selectedMemberAttendingCount = ValueNotifier(null);
  final ValueNotifier<Device?> selectedDevice = ValueNotifier(null);
  final ValueNotifier<Future<File?>?> selectedMemberProfileImage = ValueNotifier(null);

  static SelectedItemProvider of(BuildContext context){
    final provider = context.dependOnInheritedWidgetOfExactType<SelectedItemProvider>();

    assert(provider != null, "There is no SelectedItemProvider in the Widget tree.");

    return provider!;
  }

  @override
  bool updateShouldNotify(SelectedItemProvider old)
   => selectedRide != old.selectedRide && selectedMember != old.selectedMember
       && selectedDevice != old.selectedDevice;
}