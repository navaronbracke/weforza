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
        riderListFilter: riderListFilter == null ? RiderFilterOption.all : RiderFilterOption.values[riderListFilter],
        scanDuration: scanDuration ?? 20,
      );

      await write(settings);
      await _settingsRecordRef.delete(_database);

      return settings;
    }

    // TODO: read from shared prefs
  }

  @override
  Future<void> write(Settings settings) async {
    if (await _settingsRecordRef.exists(_database)) {
      await _settingsRecordRef.update(_database, settings.toMap());
    } else {
      await _settingsRecordRef.add(_database, settings.toMap());
    }
  }
}
