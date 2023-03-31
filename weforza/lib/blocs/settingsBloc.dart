
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/repository/settingsRepository.dart';

class SettingsBloc extends Bloc {
  SettingsBloc(this._repository);

  final SettingsRepository _repository;

  BehaviorSubject<bool> _submitController = BehaviorSubject();
  Stream<bool> get submitStream => _submitController.stream;

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
    final isSubmitting = _submitController.value!;
    // Still submitting.
    if(isSubmitting){
      return;
    }

    _submitController.add(true);
    await Future.delayed(Duration(milliseconds: 400), () async {
      await _repository.writeApplicationSettings(Settings(
        scanDuration: _scanDuration.floor(),
      )).then((_){
        _submitController.add(false);
      }).catchError((e) {
        _submitController.addError(e);
      });
    });
  }

  void onScanDurationChanged(double newValue) => _scanDuration = newValue;

  @override
  void dispose() {
    _submitController.close();
  }
}