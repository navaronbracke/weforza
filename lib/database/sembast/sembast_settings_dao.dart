import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weforza/database/sembast/database_tables.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/settings.dart';

/// This class represents the sembast implementation of [SettingsDao].
class SembastSettingsDao implements SettingsDao {
  SembastSettingsDao(this._database) : _settingsRecordRef = DatabaseTables.settings.record(_sembastSettingsKey);

  /// A reference to the database.
  final Database _database;

  /// The record reference for the settings record.
  final RecordRef<String, Map<String, Object?>> _settingsRecordRef;

  static final SharedPreferencesAsync _sharedPreferences = SharedPreferencesAsync();

  /// The key for the settings record in Sembast.
  static const _sembastSettingsKey = 'APPLICATION_SETTINGS';

  /// The key for the scan session excluded terms filter in shared preferences.
  static const String _scanExcludedTermsFilterKey = 'scanExcludedTermsFilter';

  /// The key for the rider list display mode in shared preferences.
  static const String _riderListDisplayModeKey = 'riderListDisplayMode';

  /// The key for the scan duration in shared preferences.
  static const String _scanDurationKey = 'scanDuration';

  @override
  Future<Settings> read() async {
    final Map<String, Object?>? sembastRecord = await _settingsRecordRef.get(_database);

    // If the record exists in the database, move it to shared preferences and return it.
    // Otherwise, read it from shared preferences.
    if (sembastRecord case {
      'excludedTermsFilter': final List<Object?>? excludedTermsFilter,
      'memberListFilter': final int? riderListFilter,
      'scanDuration': final int? scanDuration,
    }) {
      final settings = Settings(
        excludedTermsFilter: Set.of(excludedTermsFilter?.whereType<String>() ?? const Iterable.empty()),
        riderListFilter: RiderFilterOption.fromInt(riderListFilter),
        scanDuration: scanDuration,
      );

      await write(settings);
      await _settingsRecordRef.delete(_database);

      return settings;
    }

    final List<String>? excludedTermsFilter = await _sharedPreferences.getStringList(_scanExcludedTermsFilterKey);
    final int? scanDuration = await _sharedPreferences.getInt(_scanDurationKey);
    final int? riderListDisplayMode = await _sharedPreferences.getInt(_riderListDisplayModeKey);

    return Settings(
      excludedTermsFilter: Set.of(excludedTermsFilter ?? const Iterable.empty()),
      riderListFilter: RiderFilterOption.fromInt(riderListDisplayMode),
      scanDuration: scanDuration,
    );
  }

  @override
  Future<void> write(Settings settings) async {
    await Future.wait([
      _sharedPreferences.setStringList(_scanExcludedTermsFilterKey, settings.excludedTermsFilter.toList()),
      _sharedPreferences.setInt(_riderListDisplayModeKey, settings.riderListFilter.value),
      _sharedPreferences.setInt(_scanDurationKey, settings.scanDuration),
    ]);
  }
}
