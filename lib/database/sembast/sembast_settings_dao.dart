import 'package:sembast/sembast.dart';
import 'package:weforza/database/sembast/database_tables.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/model/settings/settings.dart';

/// This class represents the sembast implementation of [SettingsDao].
class SembastSettingsDao implements SettingsDao {
  SembastSettingsDao(this._database) : _settingsRecordRef = DatabaseTables.settings.record(_settingsKey);

  /// A reference to the database.
  final Database _database;

  /// The record reference for the settings record.
  final RecordRef<String, Map<String, Object?>> _settingsRecordRef;

  /// The key for the settings record.
  static const _settingsKey = 'APPLICATION_SETTINGS';

  @override
  Future<Settings> read() async {
    return Settings.of(await _settingsRecordRef.get(_database) ?? {});
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
