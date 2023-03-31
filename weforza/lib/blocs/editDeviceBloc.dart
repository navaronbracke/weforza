
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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
  ){
    deviceNameController = TextEditingController(text: deviceName);
    pageController = PageController(initialPage: deviceType.index);
    _typeController = BehaviorSubject.seeded(deviceType.index);
  }

  final DeviceRepository repository;
  final String deviceOwnerId;
  final DateTime deviceCreationDate;
  String deviceName;
  DeviceType deviceType;

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

  ///This controller manages the current page dot for the type carousel.
  StreamController<int> _typeController;
  Stream<int> get currentTypeStream => _typeController.stream;

  TextEditingController deviceNameController;

  PageController pageController;

  void onDeviceTypeChanged(int page){
    deviceType = DeviceType.values[page];
    _typeController.add(page);
  }

  @override
  void dispose() {
    _submitButtonController.close();
    _submitErrorController.close();
    _typeController.close();
    deviceNameController.dispose();
    pageController.dispose();
  }

  Future<Device> editDevice(String deviceExistsMessage, String genericErrorMessage) async {
    _submitButtonController.add(true);
    _submitErrorController.add("");//remove the previous error.
    final editedDevice = Device(
        ownerId: deviceOwnerId,
        name: deviceName,
        type: deviceType,
        creationDate: deviceCreationDate
    );

    final bool exists = await repository.deviceExists(deviceName, deviceOwnerId, deviceCreationDate).catchError((error){
      _submitButtonController.add(false);
      _submitErrorController.add(genericErrorMessage);
      return Future.error(genericErrorMessage);
    });

    if(exists){
      _submitButtonController.add(false);
      _submitErrorController.add(deviceExistsMessage);
      return Future.error(deviceExistsMessage);
    }else{
      return await repository.updateDevice(editedDevice).then((_){
        _submitButtonController.add(false);
        return editedDevice;
      }).catchError((error){
        _submitButtonController.add(false);
        _submitErrorController.add(genericErrorMessage);
        return Future.error(genericErrorMessage);
      });
    }
  }

  String validateDeviceNameInput(
      String value,
      String deviceNameIsRequired,
      String deviceNameMaxLengthMessage,
      String commaIsIllegalCharacterMessage,
      String isWhitespaceMessage)
  {
    if(value != deviceName){
      //Clear the 'device exists' error when a different input is given
      _submitErrorController.add("");
    }
    if(value == null || value.isEmpty){
      editDeviceError = deviceNameIsRequired;
    }else if(value.trim().isEmpty){
      editDeviceError = isWhitespaceMessage;
    }else if(deviceNameMaxLength < value.length){
      editDeviceError = deviceNameMaxLengthMessage;
    }else if(value.contains(",")){
      editDeviceError = commaIsIllegalCharacterMessage;
    }else{
      deviceName = value;
      editDeviceError = null;
    }
    return editDeviceError;
  }
}