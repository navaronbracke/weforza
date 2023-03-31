
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceTypePicker.dart';

class EditDeviceBloc extends Bloc implements DeviceTypePickerHandler {
  EditDeviceBloc(Device device,this._repository):
        assert(device != null && _repository != null){
    _creationDate = device.creationDate;
    newDeviceName = device.name;
    _ownerId = device.ownerId;
    _type = device.type;
  }

  DateTime _creationDate;
  String _ownerId;
  final DeviceRepository _repository;

  ///Auto validate flag for device name.
  bool autoValidateDeviceName = false;
  ///Device Name max length
  int deviceNameMaxLength = 40;

  ///Device Name input backing field
  String newDeviceName;
  ///Device type backing field.
  DeviceType _type;

  ///Form Error message
  String editDeviceError;

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

  //TODO remove the callback
  Future<void> editDevice(void Function(Device editedDevice) onSuccess,String deviceExistsMessage, String genericErrorMessage) async {
    _submitButtonController.add(true);
    _submitErrorController.add(" ");//remove the previous error.
    final editedDevice = Device(ownerId: _ownerId,name: newDeviceName,type: _type,creationDate: _creationDate);
    await _repository.deviceExists(editedDevice,_ownerId).then((exists) async {
      if(!exists){
        await _repository.updateDevice(editedDevice).then((_){
          onSuccess(editedDevice);
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

  String validateDeviceNameInput(String value,String deviceNameIsRequired,String deviceNameMaxLengthMessage){
    if(value != newDeviceName){
      //Clear the 'device exists' error when a different input is given
      _submitErrorController.add("");
    }
    if(value == null || value.isEmpty){
      editDeviceError = deviceNameIsRequired;
    }else if(deviceNameMaxLength < value.length){
      editDeviceError = deviceNameMaxLengthMessage;
    }else{
      newDeviceName = value;
      editDeviceError = null;
    }
    return editDeviceError;
  }

  @override
  DeviceType get currentValue => _type;

  @override
  void onTypeBackPressed(){
    if(_type.index == 0) return;

    _type = DeviceType.values[_type.index - 1];
  }

  @override
  void onTypeForwardPressed(){
    if(_type.index == DeviceType.values.length-1) return;

    _type = DeviceType.values[_type.index + 1];
  }
}