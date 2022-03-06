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
  }) : assert(ownerId.isNotEmpty);

  final DeviceRepository repository;
  final String ownerId;

  int deviceNameMaxLength = 40;

  final deviceNameController = TextEditingController(text: '');

  String _newDeviceName = '';

  DeviceType type = DeviceType.unknown;

  final pageController = PageController(initialPage: DeviceType.unknown.index);

  String? addDeviceError;

  final _submitButtonController = BehaviorSubject<bool>();
  Stream<bool> get submitStream => _submitButtonController;

  final BehaviorSubject<String> _submitErrorController = BehaviorSubject();
  Stream<String> get submitErrorStream => _submitErrorController;

  final _typeController = BehaviorSubject.seeded(DeviceType.unknown.index);
  Stream<int> get currentTypeStream => _typeController;

  void onDeviceTypeChanged(int page) {
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

  Future<void> addDevice(
      String deviceExistsMessage, String genericErrorMessage) async {
    _submitButtonController.add(true);
    _submitErrorController.add(''); //remove the previous error.

    final device = Device(
        ownerId: ownerId,
        name: _newDeviceName,
        type: type,
        creationDate: DateTime.now());

    final bool exists = await repository
        .deviceExists(_newDeviceName, ownerId)
        .catchError((error) {
      _submitButtonController.add(false);
      _submitErrorController.add(genericErrorMessage);
      return Future<bool>.error(genericErrorMessage);
    });

    if (exists) {
      _submitButtonController.add(false);
      _submitErrorController.add(deviceExistsMessage);
      return Future.error(deviceExistsMessage);
    } else {
      await repository.addDevice(device).catchError((error) {
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
      String isWhitespaceMessage) {
    if (value != _newDeviceName) {
      //Clear the 'device exists' error when a different input is given
      _submitErrorController.add('');
    }

    if (value == null || value.isEmpty) {
      addDeviceError = deviceNameIsRequired;
    } else if (value.trim().isEmpty) {
      addDeviceError = isWhitespaceMessage;
    } else if (deviceNameMaxLength < value.length) {
      addDeviceError = deviceNameMaxLengthMessage;
    } else if (value.contains(',')) {
      addDeviceError = commaIsIllegalCharacterMessage;
    } else {
      _newDeviceName = value;
      addDeviceError = null;
    }

    return addDeviceError;
  }
}
