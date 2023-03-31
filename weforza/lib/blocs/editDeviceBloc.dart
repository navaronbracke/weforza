
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';

class EditDeviceBloc extends Bloc {
  EditDeviceBloc({
    @required this.repository,
    @required this.deviceType,
    @required this.deviceOwnerId,
    @required this.deviceCreationDate,
    @required this.deviceName,
  }): assert(
    repository != null && deviceOwnerId != null && deviceOwnerId.isNotEmpty &&
    deviceCreationDate != null && deviceName != null && deviceType != null
  );

  final DeviceRepository repository;
  final String deviceOwnerId;
  final DateTime deviceCreationDate;
  String deviceName;
  DeviceType deviceType;

  ///Auto validate flag for device name.
  bool autoValidateDeviceName = false;
  ///Device Name max length
  int deviceNameMaxLength = 40;

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

  Future<Device> editDevice(String deviceExistsMessage, String genericErrorMessage) async {
    _submitButtonController.add(true);
    _submitErrorController.add(" ");//remove the previous error.
    final editedDevice = Device(
        ownerId: deviceOwnerId,
        name: deviceName,
        type: deviceType,
        creationDate: deviceCreationDate
    );
    await repository.deviceExists(editedDevice,deviceOwnerId).then((exists) async {
      if(!exists){
        await repository.updateDevice(editedDevice).then((_){
          _submitButtonController.add(false);
          return editedDevice;
        },onError: (error){
          _submitButtonController.add(false);
          _submitErrorController.add(genericErrorMessage);
          return Future.error(genericErrorMessage);
        });
      }else{
        _submitButtonController.add(false);
        _submitErrorController.add(deviceExistsMessage);
        return Future.error(deviceExistsMessage);
      }
    },onError: (error){
      _submitButtonController.add(false);
      _submitErrorController.add(genericErrorMessage);
      return Future.error(genericErrorMessage);
    });
    return Future.error(genericErrorMessage);
  }

  String validateDeviceNameInput(String value,String deviceNameIsRequired,String deviceNameMaxLengthMessage){
    if(value != deviceName){
      //Clear the 'device exists' error when a different input is given
      _submitErrorController.add("");
    }
    if(value == null || value.isEmpty){
      editDeviceError = deviceNameIsRequired;
    }else if(deviceNameMaxLength < value.length){
      editDeviceError = deviceNameMaxLengthMessage;
    }else{
      deviceName = value;
      editDeviceError = null;
    }
    return editDeviceError;
  }
}