
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/widgets/pages/deviceOverview/addDevice/addDeviceSubmitState.dart';

class AddDeviceBloc extends Bloc {
  AddDeviceBloc(this.ownerUuid,this._repository):
        assert(ownerUuid != null && ownerUuid.isNotEmpty && _repository != null);

  ///The id of the owner to add the device for.
  final String ownerUuid;
  final DeviceRepository _repository;

  ///Auto validate flag for device name.
  bool autoValidateNewDeviceName = false;
  ///Device Name max length
  int deviceNameMaxLength = 50;

  ///Device Name input backing field
  String _newDeviceName;
  ///Device type backing field.
  DeviceType type;

  ///Submit error message
  String addDeviceError;

  final StreamController<AddDeviceSubmitState> _addDeviceController = BehaviorSubject();
  Stream<AddDeviceSubmitState> get addDeviceStream => _addDeviceController.stream;

  @override
  void dispose() {
    _addDeviceController.close();
  }

  void addDevice(void Function(Device addedDevice) onSuccess) async {
    _addDeviceController.add(AddDeviceSubmitState.SUBMIT);
    await _repository.deviceExists(_newDeviceName).then((exists) async {
      if(!exists){
        final device = Device(ownerId: ownerUuid,name: _newDeviceName,type: type);
        await _repository.addDevice(device).then((_){
          onSuccess(device);
        },onError: (error){
          _addDeviceController.add(AddDeviceSubmitState.ERROR);
        });
      }else{
        _addDeviceController.add(AddDeviceSubmitState.DEVICE_EXISTS);
      }
    },onError: (error){
      _addDeviceController.add(AddDeviceSubmitState.ERROR);
    });
  }

  String validateNewDeviceInput(String value,String deviceNameIsRequired,String deviceNameMaxLengthMessage){
    _addDeviceController.add(AddDeviceSubmitState.IDLE);//clear the device exists error
    if(value == null || value.isEmpty){
      addDeviceError = deviceNameIsRequired;
    }else if(deviceNameMaxLength < value.length){
      addDeviceError = deviceNameMaxLengthMessage;
    }else{
      _newDeviceName = value;
      addDeviceError = null;
    }
    return addDeviceError;
  }
}