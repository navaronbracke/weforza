
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceTypePicker.dart';

class AddDeviceBloc extends Bloc implements DeviceTypePickerHandler {
  AddDeviceBloc(this._repository): assert(_repository != null);

  ///The id of the owner to add the device for.
  final String ownerUuid = MemberProvider.selectedMember.uuid;
  final DeviceRepository _repository;

  ///Auto validate flag for device name.
  bool autoValidateNewDeviceName = false;
  ///Device Name max length
  int deviceNameMaxLength = 40;

  ///Device Name input backing field
  String _newDeviceName = "";
  ///Device type backing field.
  DeviceType _type = DeviceType.UNKNOWN;

  ///Form Error message
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

  Future<void> addDevice(void Function(Device addedDevice) onSuccess,String deviceExistsMessage, String genericErrorMessage) async {
    _submitButtonController.add(true);
    _submitErrorController.add(" ");//remove the previous error.
    final device = Device(ownerId: ownerUuid,name: _newDeviceName,type: _type,creationDate: DateTime.now());
    await _repository.deviceExists(device).then((exists) async {
      if(!exists){
        await _repository.addDevice(device).then((_){
          onSuccess(device);
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
    if(value != _newDeviceName){
      //Clear the 'device exists' error when a different input is given
      _submitErrorController.add("");
    }
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