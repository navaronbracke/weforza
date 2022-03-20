import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/extended_settings.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/member_list_filter_delegate.dart';
import 'package:weforza/model/save_settings_delegate.dart';
import 'package:weforza/model/scan_duration_delegate.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/repository/settings_repository_provider.dart';

/// This provider provides the application settings.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier(
    // This default value is overwritten with the preloaded one in main.dart
    currentSettings: Settings(),
    settingsRepository: ref.read(settingsRepositoryProvider),
  );
});

class SettingsNotifier extends StateNotifier<Settings>
    implements
        SaveSettingsDelegate,
        ScanDurationDelegate,
        MemberListFilterDelegate {
  SettingsNotifier({
    required Settings currentSettings,
    required this.settingsRepository,
  })  : _scanDuration = currentSettings.scanDuration.toDouble(),
        _memberListFilter = currentSettings.memberListFilter,
        super(currentSettings);

  MemberFilterOption _memberListFilter;

  @override
  MemberFilterOption get memberListFilter => _memberListFilter;

  /// The repository that loads the settings.
  final SettingsRepository settingsRepository;

  Future<void>? _saveSettingsFuture;

  @override
  Future<void>? get saveSettingsFuture => _saveSettingsFuture;

  double _scanDuration;

  @override
  double get currentScanDuration => _scanDuration.floorToDouble();

  @override
  double get maxScanDuration => 60;

  @override
  double get minScanDuration => 10;

  @override
  void onScanDurationChanged(double newValue) {
    if (_scanDuration != newValue) {
      _scanDuration = newValue;
    }
  }

  @override
  void onMemberListFilterChanged(MemberFilterOption newValue) {
    if (_memberListFilter != newValue) {
      _memberListFilter = newValue;
    }
  }

  @override
  void saveSettings() async {
    // Use an artificial delay to make it look smoother.
    _saveSettingsFuture = Future.delayed(const Duration(milliseconds: 500), () {
      final newSettings = Settings(
        scanDuration: _scanDuration.floor(),
        memberListFilter: _memberListFilter,
      );

      return settingsRepository.writeApplicationSettings(newSettings).then((_) {
        state = newSettings;
      });
    });
  }

  Future<ExtendedSettings> loadExtendedSettings() async {
    return ExtendedSettings(state, await settingsRepository.hasRides());
  }
}
