
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';

class AddDeviceBloc extends Bloc {
  AddDeviceBloc({
    required this.repository,
    required this.ownerId,
  }): assert(ownerId.isNotEmpty);

  final DeviceRepository repository;
  final String ownerId;

  ///Device Name max length
  int deviceNameMaxLength = 40;

  TextEditingController deviceNameController = TextEditingController(text: "");

  ///Device Name input backing field
  String _newDeviceName = "";
  ///Device type backing field.
  DeviceType type = DeviceType.UNKNOWN;

  final PageController pageController = PageController(
      initialPage: DeviceType.UNKNOWN.index
  );

  ///Form Error message
  String? addDeviceError;

  ///This controller manages the submit button/loading indicator.
  final StreamController<bool> _submitButtonController = BehaviorSubject();
  Stream<bool> get submitStream => _submitButtonController.stream;

  ///This controller manages the error message for the submit.
  final BehaviorSubject<String> _submitErrorController = BehaviorSubject();
  Stream<String> get submitErrorStream => _submitErrorController.stream;

  ///This controller manages the current page dot for the type carousel.
  final StreamController<int> _typeController = BehaviorSubject.seeded(DeviceType.UNKNOWN.index);
  Stream<int> get currentTypeStream => _typeController.stream;

  void onDeviceTypeChanged(int page){
    type = DeviceType.values[page];
    _typeController.add(page);
  }

  @override
  void dispose() {
    _submitButtonController.close();
    _submitErrorController.close();
    _typeController.close();
    pageController.dispose();
    deviceNameController.dispose();
  }

  Future<void> addDevice(String deviceExistsMessage, String genericErrorMessage) async {
    _submitButtonController.add(true);
    _submitErrorController.add("");//remove the previous error.

    final device = Device(
        ownerId: ownerId,
        name: _newDeviceName,
        type: type,
        creationDate: DateTime.now()
    );

    final bool exists = await repository.deviceExists(_newDeviceName, ownerId).catchError((error){
      _submitButtonController.add(false);
      _submitErrorController.add(genericErrorMessage);
      return Future<bool>.error(genericErrorMessage);
    });

    if(exists){
      _submitButtonController.add(false);
      _submitErrorController.add(deviceExistsMessage);
      return Future.error(deviceExistsMessage);
    }else{
      await repository.addDevice(device).catchError((error){
        _submitButtonController.add(false);
        _submitErrorController.add(genericErrorMessage);
        return Future.error(genericErrorMessage);
      });
    }
  }

  String? validateNewDeviceInput(
      String? value,
      String deviceNameIsRequired,
      String deviceNameMaxLengthMessage,
      String commaIsIllegalCharacterMessage,
      String isWhitespaceMessage)
  {
    if(value != _newDeviceName){
      //Clear the 'device exists' error when a different input is given
      _submitErrorController.add("");
    }

    if(value == null || value.isEmpty){
      addDeviceError = deviceNameIsRequired;
    }else if(value.trim().isEmpty){
      addDeviceError = isWhitespaceMessage;
    }else if(deviceNameMaxLength < value.length){
      addDeviceError = deviceNameMaxLengthMessage;
    }else if(value.contains(",")){
      addDeviceError = commaIsIllegalCharacterMessage;
    }else{
      _newDeviceName = value;
      addDeviceError = null;
    }

    return addDeviceError;
  }
}