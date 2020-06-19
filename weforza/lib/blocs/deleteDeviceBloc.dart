
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';

class DeleteDeviceBloc extends Bloc {
  DeleteDeviceBloc(
        this.device,
        this.itemIndex,
        this._repository
      ): assert(
    _repository != null && device != null && device.name != null &&
        device.name.isNotEmpty && itemIndex != null
  );

  final int itemIndex;
  final DeviceRepository _repository;
  final Device device;

  final StreamController<bool> _deviceDeletingStream = BehaviorSubject();
  Stream<bool> get isDeletedStream => _deviceDeletingStream.stream;

  //TODO remove the callback
  Future<void> deleteDevice(String deleteDeviceError, VoidCallback onSuccess) async {
    _deviceDeletingStream.add(true);
    await _repository.removeDevice(device.name).then((_) => onSuccess(),
        onError: (e) => _deviceDeletingStream.addError(deleteDeviceError));
  }

  @override
  void dispose() {
    _deviceDeletingStream.close();
  }

}