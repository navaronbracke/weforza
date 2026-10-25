import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

/// This provider provides the application settings.
final settingsProvider = AsyncNotifierProvider(SettingsNotifier.new);

/// The notifier that manages the settings.
class SettingsNotifier extends AsyncNotifier<Settings> {
  @override
  FutureOr<Settings> build() {
    final SettingsRepository settingsRepository = SettingsRepository(ref.watch(databaseProvider));

    return settingsRepository.read();
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

  Future<void> _saveSettings(Settings settings) async {
    if (state case AsyncData(:final value) when value == settings) {
      return;
    }

    final SettingsRepository settingsRepository = SettingsRepository(ref.read(databaseProvider));

    await settingsRepository.write(settings);

    if (ref.mounted) {
      state = AsyncData(settings);
    }
  }
}
