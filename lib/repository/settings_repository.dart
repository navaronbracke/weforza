import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/settings.dart';

class SettingsRepository {
  new(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// The Shared Preferences instance that manages the primitive value settings,
  /// such as the scan duration and the rider filter options.
  static final SharedPreferencesAsync _sharedPreferences = SharedPreferencesAsync();

  /// The key for the rider list display mode in shared preferences.
  static const String _riderListDisplayModeKey = 'riderListDisplayMode';

  /// The key for the scan duration in shared preferences.
  static const String _scanDurationKey = 'scanDuration';

  /// Read the current application settings.
  Future<Settings> read() async {
    final List<ExcludedTerm> excludedTerms = await _database.excludedTerms.select().get();
    final int? scanDuration = await _sharedPreferences.getInt(_scanDurationKey);
    final int? riderListDisplayMode = await _sharedPreferences.getInt(_riderListDisplayModeKey);

    return Settings(
      excludedTermsFilter: {...excludedTerms},
      riderListFilter: RiderFilterOption.fromInt(riderListDisplayMode),
      scanDuration: scanDuration,
    );
  }

  /// Write the new [settings].
  Future<void> write(Settings settings) {
    return Future.wait<void>([
      _writeExcludedTerms(settings.excludedTermsFilter),
      _sharedPreferences.setInt(_riderListDisplayModeKey, settings.riderListFilter.value),
      _sharedPreferences.setInt(_scanDurationKey, settings.scanDuration),
    ]);
  }

  Future<void> _writeExcludedTerms(Set<ExcludedTerm> excludedTerms) {
    return _database.transaction(() async {
      final existingTermsAsList = await _database.excludedTerms.select().get();
      final existingTerms = {...existingTermsAsList};

      final termsToAdd = excludedTerms.difference(existingTerms);
      final termsToDelete = existingTerms.difference(excludedTerms).map((t) => t.term);

      await _database.batch((batch) {
        batch.deleteWhere(_database.excludedTerms, (t) => t.term.isIn(termsToDelete));
        batch.insertAll(_database.excludedTerms, termsToAdd, onConflict: DoNothing());
      });
    });
  }
}
