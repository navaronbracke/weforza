import 'package:sembast/sembast.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/model/settings.dart';

/// This class represents an interface
/// to read and write the application settings.
abstract class SettingsDao {
  /// Read the current application settings.
  Future<Settings> read();

  /// Write the new [settings].
  Future<void> write(Settings settings);
}

/// The default implementation of [SettingsDao].
class SettingsDaoImpl implements SettingsDao {
  SettingsDaoImpl(
    this._database,
    DatabaseTables tables,
  ) : _settingsRecordRef = tables.settings.record(_settingsKey);

  /// A reference to the database.
  final Database _database;

  /// The record reference for the settings record.
  final RecordRef<String, Map<String, dynamic>> _settingsRecordRef;

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
