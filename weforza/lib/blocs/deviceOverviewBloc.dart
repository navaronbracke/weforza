
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';

abstract class DeviceOverviewHandler {
  bool get isShowingAddDeviceForm;

  List<Device> get devices;

  void requestAddForm();
}

class DeviceOverviewBloc extends Bloc implements DeviceOverviewHandler {
  DeviceOverviewBloc(this.devices): assert(devices != null);

  final List<Device> devices;

  Device deviceToEdit;
  void Function(Device editedDevice) onEditSuccess;

  void onEditDeviceRequested(Device device, void Function(Device editedDevice) onSucessCallback){
    assert(device != null && onSucessCallback != null);
    deviceToEdit = device;
    onEditSuccess = onSucessCallback;
    _overviewDisplayModeController.add(DeviceOverviewDisplayMode.EDIT);
  }

  final StreamController<DeviceOverviewDisplayMode> _overviewDisplayModeController = BehaviorSubject();
  Stream<DeviceOverviewDisplayMode> get displayMode => _overviewDisplayModeController.stream;

  bool isShowingAddDeviceForm = true;

  void addDevice(Device device){
    devices.add(device);
  }

  @override
  void dispose() {
    _overviewDisplayModeController.close();
  }

  @override
  void requestAddForm() {
    isShowingAddDeviceForm = true;
    _overviewDisplayModeController.add(DeviceOverviewDisplayMode.ADD);
  }

}

///This enum defines the display modes for DeviceOverviewPage.
///[DeviceOverviewDisplayMode.ADD] Shows the device list and an add device form.
///[DeviceOverviewDisplayMode.EDIT] Shows an edit form for the selected device.
///[DeviceOverviewDisplayMode.DELETE] Shows a confirmation option for deleting a selected device.
enum DeviceOverviewDisplayMode {
  ADD,EDIT,DELETE
}