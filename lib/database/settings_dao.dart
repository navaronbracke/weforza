import 'package:sembast/sembast.dart';
import 'package:weforza/model/settings.dart';

///This class defines a contract for managing application settings.
abstract class ISettingsDao {
  /// Read the [Settings] from the database.
  Future<Settings> readApplicationSettings();

  /// Write the given settings to the database.
  Future<void> writeApplicationSettings(Settings newSettings);
}

class SettingsDao implements ISettingsDao {
  SettingsDao(this._database, this._settingsStore);

  /// The key for the settings record.
  static const _settingsKey = 'APPLICATION_SETTINGS';

  /// A reference to the database.
  final Database _database;

  /// A  reference to the [Settings] store.
  final StoreRef<String, Map<String, dynamic>> _settingsStore;

  @override
  Future<Settings> readApplicationSettings() async {
    return Settings.of(
      await _settingsStore.record(_settingsKey).get(_database) ?? {},
    );
  }

  @override
  Future<void> writeApplicationSettings(Settings newSettings) async {
    final recordRef = _settingsStore.record(_settingsKey);

    if (await recordRef.exists(_database)) {
      await recordRef.update(_database, newSettings.toMap());
    } else {
      await recordRef.add(_database, newSettings.toMap());
    }
  }
}
