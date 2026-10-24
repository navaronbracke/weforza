import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

/// This provider provides the application settings.
final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<Settings>>(
  (ref) => SettingsNotifier(SettingsRepository(ref.watch(databaseProvider))),
);

/// The notifier that manages the settings.
class SettingsNotifier extends StateNotifier<AsyncValue<Settings>> {
  new(this._settingsRepository) : super(const AsyncData(Settings())) {
    _loadInitialSettings();
  }

  /// The repository that manages the settings.
  final SettingsRepository _settingsRepository;

  Settings _copyWith({Set<ExcludedTerm>? excludedTermsFilter, RiderFilterOption? riderListFilter, int? scanDuration}) {
    if (state case AsyncData(:final value)) {
      return value.copyWith(
        excludedTermsFilter: excludedTermsFilter ?? value.excludedTermsFilter,
        riderListFilter: riderListFilter ?? value.riderListFilter,
        scanDuration: scanDuration ?? value.scanDuration,
      );
    }

    return Settings(
      excludedTermsFilter: excludedTermsFilter ?? const {},
      riderListFilter: riderListFilter ?? Settings.defaultRiderListFilter,
      scanDuration: scanDuration ?? Settings.defaultScanDuration,
    );
  }

  Future<void> _loadInitialSettings() async {
    final settings = await _settingsRepository.read();

    if (mounted) {
      state = AsyncData(settings);
    }
  }

  Future<void> _saveSettings(Settings settings) async {
    if (state case AsyncData(:final value) when value == settings) {
      return;
    }

    await _settingsRepository.write(settings);

    if (mounted) {
      state = AsyncData(settings);
    }
  }

  /// Save the list of [excludedTerms].
  Future<void> saveExcludedTerms(Set<ExcludedTerm> excludedTerms) {
    return _saveSettings(_copyWith(excludedTermsFilter: excludedTerms));
  }

  /// Save the [riderListFilter] value.
  Future<void> saveRiderListFilter(RiderFilterOption riderListFilter) {
    return _saveSettings(_copyWith(riderListFilter: riderListFilter));
  }

  /// Save the [scanDuration] value.
  Future<void> saveScanDuration(int scanDuration) {
    return _saveSettings(_copyWith(scanDuration: scanDuration));
  }
}
