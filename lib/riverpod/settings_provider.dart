import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member_filter_option.dart';
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

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier({
    required Settings currentSettings,
    required this.settingsRepository,
  })  : _scanDuration = currentSettings.scanDuration.toDouble(),
        _memberListFilter = currentSettings.memberListFilter,
        super(currentSettings);

  final double maxScanValue = 60;

  final double minScanValue = 10;

  /// The repository that loads the settings.
  final SettingsRepository settingsRepository;

  /// The future that keeps track of the save settings computation.
  Future<void>? saveSettingsFuture;

  /// The current scan duration setting.
  double _scanDuration;

  /// The current member list filter setting.
  MemberFilterOption _memberListFilter;

  /// Get the current scan duration, as a double.
  double get scanDuration => _scanDuration.floorToDouble();

  /// Get the current member list filter setting.
  MemberFilterOption get memberListFilter => _memberListFilter;

  /// Update the scan duration to the new [value].
  void updateScanDuration(double value) {
    if (_scanDuration != value) {
      _scanDuration = value;
    }
  }

  /// Update the member list filter to the new [value].
  void updateMemberListFilter(MemberFilterOption value) {
    if (_memberListFilter != value) {
      _memberListFilter = value;
    }
  }

  void saveSettings() async {
    // Use an ertificial delay to make it look smoother.
    saveSettingsFuture = Future.delayed(const Duration(milliseconds: 500), () {
      return settingsRepository.writeApplicationSettings(
        Settings(
          scanDuration: _scanDuration.floor(),
          memberListFilter: _memberListFilter,
        ),
      );
    });
  }
}
