
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';

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

  ///This controller manages the submit button/loading indicator.
  final StreamController<bool> _submitButtonController = BehaviorSubject();
  Stream<bool> get submitStream => _submitButtonController.stream;

  ///This controller manages the error message for the submit.
  final StreamController<String> _submitErrorController = BehaviorSubject();
  Stream<String> get submitErrorStream => _submitErrorController.stream;

  @override
  void dispose() {
    _submitButtonController.close();
    _submitErrorController.close();
  }

  void addDevice(void Function(Device addedDevice) onSuccess,String deviceExistsMessage, String genericErrorMessage) async {
    _submitButtonController.add(true);
    _submitErrorController.add(" ");//remove the previous error.
    await _repository.deviceExists(_newDeviceName).then((exists) async {
      if(!exists){
        final device = Device(ownerId: ownerUuid,name: _newDeviceName,type: type);
        await _repository.addDevice(device).then((_){
          onSuccess(device);//TODO add device to list + set new text controller / reset type dropdown + autovalidate flag? + set device provider to reload true
          _submitButtonController.add(false);
        },onError: (error){
          _submitButtonController.add(false);
          _submitErrorController.add(genericErrorMessage);
        });
      }else{
        _submitButtonController.add(false);
        _submitErrorController.add(deviceExistsMessage);
      }
    },onError: (error){
      _submitButtonController.add(false);
      _submitErrorController.add(genericErrorMessage);
    });
  }

  String validateNewDeviceInput(String value,String deviceNameIsRequired,String deviceNameMaxLengthMessage){
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