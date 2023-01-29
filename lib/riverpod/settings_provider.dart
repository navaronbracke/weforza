import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/settings_repository.dart';

/// This provider provides the application settings.
///
/// This provider is overridden at startup with the preloaded settings.
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) {
    throw UnsupportedError('The settings should be preloaded at startup.');
  },
);

/// The notifier that manages the settings.
class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(
    super.initialValue,
    this._settingsRepository,
  );

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
    final Settings newSettings = state.copyWith(
      excludedTermsFilter: excludedTerms,
    );

    return _saveSettings(newSettings);
  }

  /// Save the [riderListFilter] value.
  Future<void> saveRiderListFilter(RiderFilterOption riderListFilter) {
    final Settings newSettings = state.copyWith(
      riderListFilter: riderListFilter,
    );

    return _saveSettings(newSettings);
  }

  /// Save the [scanDuration] value.
  Future<void> saveScanDuration(int scanDuration) {
    final Settings newSettings = state.copyWith(scanDuration: scanDuration);

    return _saveSettings(newSettings);
  }
}
