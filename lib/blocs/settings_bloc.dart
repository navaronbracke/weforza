import 'dart:async';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/repository/settingsRepository.dart';

class SettingsBloc extends Bloc {
  SettingsBloc(this._repository);

  final SettingsRepository _repository;

  // This Future holds the save settings computation.
  Future<void>? saveSettingsFuture;

  late double _scanDuration;

  late MemberFilterOption _memberListFilter;

  double get scanDuration => _scanDuration.floorToDouble();

  MemberFilterOption get memberListFilter => _memberListFilter;

  final double maxScanValue = 60;

  final double minScanValue = 10;

  Future<Settings> loadSettings() async {
    final settings = await _repository.loadApplicationSettings();

    _scanDuration = settings.scanDuration.toDouble();
    _memberListFilter = settings.memberListFilter;

    return settings;
  }

  void saveSettings() async {
    saveSettingsFuture = Future.delayed(const Duration(milliseconds: 500), () {
      return _repository.writeApplicationSettings(
        Settings(
          scanDuration: _scanDuration.floor(),
          memberListFilter: _memberListFilter,
        ),
      );
    });
  }

  void onScanDurationChanged(double newValue) => _scanDuration = newValue;

  void onMemberListFilterChanged(MemberFilterOption newValue) =>
      _memberListFilter = newValue;

  @override
  void dispose() {}
}
