
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';

class DeviceOverviewBloc extends Bloc {
  DeviceOverviewBloc(this.devices): assert(devices != null);

  final List<Device> devices;

  final StreamController<DeviceOverviewDisplayMode> _overviewDisplayModeController = BehaviorSubject();
  Stream<DeviceOverviewDisplayMode> get displayMode => _overviewDisplayModeController.stream;


  @override
  void dispose() {
    _overviewDisplayModeController.close();
  }

}

///This enum defines the display modes for DeviceOverviewPage.
///[DeviceOverviewDisplayMode.ADD] Shows the device list and an add device form.
///[DeviceOverviewDisplayMode.EDIT] Shows an edit form for the selected device.
///[DeviceOverviewDisplayMode.DELETE] Shows a confirmation option for deleting a selected device.
enum DeviceOverviewDisplayMode {
  ADD,EDIT,DELETE
}