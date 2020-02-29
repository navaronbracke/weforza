
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/settings/scanDurationOption.dart';
import 'package:weforza/widgets/pages/settings/settingsSubmit.dart';
import 'package:weforza/widgets/pages/settings/showAllScanDevicesOption.dart';

class SettingsBloc extends Bloc implements SettingsSubmitHandler {
  SettingsBloc(this._repository): assert(_repository != null){
    onSubmit = () async => await saveSettings();
  }

  final SettingsRepository _repository;

  final ScanDurationHandlerDelegate _scanDurationHandler = ScanDurationHandlerDelegate();
  final ShowAllDevicesHandlerDelegate _showAllDevicesHandler = ShowAllDevicesHandlerDelegate();

  ScanDurationHandler get scanDurationHandler => _scanDurationHandler;
  ShowAllScanDevicesHandler get showAllDevicesHandler => _showAllDevicesHandler;

  bool get shouldLoadSettings => Settings.instance == null;

  StreamController<SettingsDisplayMode> _displayModeController = BehaviorSubject();
  Stream<SettingsDisplayMode> get displayMode => _displayModeController.stream;

  StreamController<bool> _submitController = BehaviorSubject();
  Stream<bool> get submitStream => _submitController.stream;


  Future<void> loadSettingsFromDatabase() async {
    _displayModeController.add(SettingsDisplayMode.LOADING);
    await _repository.loadApplicationSettings().then((_){
      loadSettingsFromMemory();
    },onError: (e){
      _displayModeController.add(SettingsDisplayMode.LOADING_ERROR);
      _submitController.addError(e);
    });
  }

  Future<void> saveSettings() async {
    _submitController.add(true);
    await _repository.writeApplicationSettings(Settings(
        scanDuration: _scanDurationHandler.scanDuration,
        showAllScannedDevices: _showAllDevicesHandler.showAllScannedDevices
    )).then((_){
      _submitController.add(false);
    },onError: (e){
      _displayModeController.add(SettingsDisplayMode.SUBMIT_ERROR);
      _submitController.addError(e);
    });
  }

  void loadSettingsFromMemory(){
    final settings = Settings.instance;
    _scanDurationHandler.scanDuration = settings.scanDuration;
    _showAllDevicesHandler.showAllScannedDevices = settings.showAllScannedDevices;
    _displayModeController.add(SettingsDisplayMode.IDLE);
  }

  @override
  void dispose() {
    _displayModeController.close();
    _submitController.close();
  }

  @override
  VoidCallback onSubmit;

}

///This class handles changes for the scan duration for [SettingsBloc].
class ScanDurationHandlerDelegate implements ScanDurationHandler {
  ScanDurationHandlerDelegate(){
    onChanged = (value) => scanDuration = value.floor();
  }

  int scanDuration;

  @override
  void Function(double value) onChanged;

  @override
  double get currentValue => scanDuration.floorToDouble();

  @override
  double get maxScanValue => 60;

  @override
  double get minScanValue => 10;
}

///This class handles changes for the 'show all devices during a scan' flag.
class ShowAllDevicesHandlerDelegate implements ShowAllScanDevicesHandler {
  ShowAllDevicesHandlerDelegate(){
    onChanged = (value) => showAllScannedDevices = value;
  }

  bool showAllScannedDevices;

  @override
  void Function(bool value) onChanged;

  @override
  bool get currentValue => showAllScannedDevices;

}

enum SettingsDisplayMode {
  LOADING,
  IDLE,
  LOADING_ERROR,
  SUBMIT_ERROR
}