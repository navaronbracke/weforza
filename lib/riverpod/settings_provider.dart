import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the initial value for the application settings.
///
/// This provider should be overridden with the preloaded settings during application startup.
final initialSettingsProvider = Provider<Settings>(
  (_) => throw UnsupportedError('The initial settings should be preloaded at startup.'),
);

/// This provider provides the application settings.
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(ref.read(initialSettingsProvider), SettingsRepository(ref.read(settingsDaoProvider))),
);

/// The notifier that manages the settings.
class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(super.initialValue, this._settingsRepository);

  /// The repository that manages the settings.
  final SettingsRepository _settingsRepository;

  Future<void> _saveSettings(Settings settings) async {
    if (state == settings) {
      return;
    }

    await _settingsRepository.write(settings);

    if (mounted) {
      state = settings;
    }
  }

  /// Save the list of [excludedTerms].
  Future<void> saveExcludedTerms(Set<String> excludedTerms) {
    final Settings newSettings = state.copyWith(excludedTermsFilter: excludedTerms);

    return _saveSettings(newSettings);
  }

  /// Save the [riderListFilter] value.
  Future<void> saveRiderListFilter(RiderFilterOption riderListFilter) {
    final Settings newSettings = state.copyWith(riderListFilter: riderListFilter);

    return _saveSettings(newSettings);
  }

  /// Save the [scanDuration] value.
  Future<void> saveScanDuration(int scanDuration) {
    final Settings newSettings = state.copyWith(scanDuration: scanDuration);

    return _saveSettings(newSettings);
  }
}
