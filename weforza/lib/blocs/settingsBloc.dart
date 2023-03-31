
import 'dart:async';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/repository/settingsRepository.dart';

class SettingsBloc extends Bloc {
  SettingsBloc(this._repository);

  final SettingsRepository _repository;

  // This Future holds the save settings computation.
  Future<void>? saveSettingsFuture;

  late double _scanDuration;

  double get scanDuration => _scanDuration.floorToDouble();

  final double maxScanValue = 60;

  final double minScanValue = 10;

  Future<Settings> loadSettings() async {
    final settings = await _repository.loadApplicationSettings();

    _scanDuration = settings.scanDuration.toDouble();

    return settings;
  }

  void saveSettings() async {
    saveSettingsFuture = Future.delayed(Duration(milliseconds: 500), () {
      return _repository.writeApplicationSettings(
        Settings(scanDuration: _scanDuration.floor()),
      );
    });
  }

  void onScanDurationChanged(double newValue) => _scanDuration = newValue;

  @override
  void dispose() {}
}