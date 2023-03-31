
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/repository/settingsRepository.dart';

class SettingsBloc extends Bloc {
  SettingsBloc(this._repository): assert(_repository != null);

  final SettingsRepository _repository;

  StreamController<bool> _submitController = BehaviorSubject();
  Stream<bool> get submitStream => _submitController.stream;

  Future<void> settingsFuture;

  double _scanDuration;

  double get scanDuration => _scanDuration.floorToDouble();

  double get maxScanValue => 60;

  double get minScanValue => 10;

  String get appVersion => _repository.instance.packageInfo.version;

  String get appBuildNumber => _repository.instance.packageInfo.buildNumber;

  void loadSettings(){
    if(_repository.instance == null){
      //We put an artificial delay here to decrease the feeling of popping in.
      //See https://www.youtube.com/watch?v=O6ZQ9r8a3iw
      settingsFuture = Future.delayed(Duration(seconds: 1),() async {
        await _repository.loadApplicationSettings();
        _scanDuration = _repository.instance.scanDuration.toDouble();
      });
    } else {
      _scanDuration = _repository.instance.scanDuration.toDouble();
      settingsFuture = Future.value(null);
    }
  }

  Future<void> saveSettings() async {
    _submitController.add(true);
    await Future.delayed(Duration(milliseconds: 400), () async {
      await _repository.writeApplicationSettings(Settings(
        scanDuration: _scanDuration.floor(),
      )).then((_){
        _submitController.add(false);
      },onError: (e){
        _submitController.addError(e);
        settingsFuture = Future.error(e);
      });
    });
  }

  void onScanDurationChanged(double newValue) => _scanDuration = newValue;

  @override
  void dispose() {
    _submitController.close();
  }

}