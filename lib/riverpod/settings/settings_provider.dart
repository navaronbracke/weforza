import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/rider/rider_list_display_mode.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/model/settings/user_preferences.dart';
import 'package:weforza/repository/excluded_terms_repository.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

/// This provider provides the application settings.
final settingsProvider = AsyncNotifierProvider(SettingsNotifier.new);

/// The notifier that manages the settings.
class SettingsNotifier extends AsyncNotifier<Settings> {
  @override
  FutureOr<Settings> build() {
    final SettingsRepository settingsRepository = SettingsRepository(
      ExcludedTermsRepository(ref.watch(databaseProvider)),
    );

    return settingsRepository.read();
  }

  /// Save the list of [excludedTerms].
  Future<void> saveExcludedTerms(Set<ExcludedTerm> excludedTerms) {
    return _saveSettings(_copyWith(excludedTermsFilter: excludedTerms));
  }

  /// Save the [riderListDisplayMode] value.
  Future<void> saveRiderListDisplayMode(RiderListDisplayMode riderListDisplayMode) {
    return _saveSettings(_copyWith(riderListDisplayMode: riderListDisplayMode));
  }

  /// Save the [scanDuration] value.
  Future<void> saveScanDuration(int scanDuration) {
    return _saveSettings(_copyWith(scanDuration: scanDuration));
  }

  Settings _copyWith({
    Set<ExcludedTerm>? excludedTermsFilter,
    RiderListDisplayMode? riderListDisplayMode,
    int? scanDuration,
  }) {
    if (state case AsyncData(:final value)) {
      return value.copyWith(
        excludedTermsFilter: excludedTermsFilter ?? value.excludedTermsFilter,
        userPreferences: value.userPreferences.copyWith(
          riderListDisplayMode: riderListDisplayMode ?? value.userPreferences.riderListDisplayMode,
          scanDuration: scanDuration ?? value.userPreferences.scanDuration,
        ),
      );
    }

    return Settings(
      excludedTermsFilter: excludedTermsFilter ?? const {},
      userPreferences: .fromValues(
        riderListDisplayMode: riderListDisplayMode ?? UserPreferences.defaultPreferences.riderListDisplayMode,
        scanDuration: scanDuration ?? UserPreferences.defaultPreferences.scanDuration,
      ),
    );
  }

  Future<void> _saveSettings(Settings settings) async {
    if (state case AsyncData(:final value) when value == settings) {
      return;
    }

    final SettingsRepository settingsRepository = SettingsRepository(
      ExcludedTermsRepository(ref.watch(databaseProvider)),
    );

    await settingsRepository.write(settings);

    if (ref.mounted) {
      state = AsyncData(settings);
    }
  }
}
