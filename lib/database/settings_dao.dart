import 'package:sembast/sembast.dart';
import 'package:weforza/model/settings.dart';

///This class defines a contract for managing application settings.
abstract class ISettingsDao {
  /// Read the [Settings] from the database.
  Future<Settings> readApplicationSettings();

  Future<void> writeApplicationSettings(Settings newSettings);
}

class SettingsDao implements ISettingsDao {
  SettingsDao(this._database, this._settingsStore, this._ridesStore);

  ///The key for the settings record.
  static const _settingsKey = 'APPLICATION_SETTINGS';

  ///A reference to the database.
  final Database _database;

  ///A reference to the [Settings] store.
  final StoreRef<String, Map<String, dynamic>> _settingsStore;

  /// A reference to the rides store.
  /// We use it to check if there is a ride calendar.
  final StoreRef<String, Map<String, dynamic>> _ridesStore;

  @override
  Future<Settings> readApplicationSettings() async {
    final settingsRecord = await _settingsStore.findFirst(_database);

    final settings =
        settingsRecord == null ? Settings() : Settings.of(settingsRecord.value);

    // There is a calendar when there is 1+ rides.
    // Rides can exists without attendants, thus we don't check on that.
    settings.hasRideCalendar =
        await _ridesStore.count(_database).then((count) => count > 0);

    return settings;
  }

  @override
  Future<void> writeApplicationSettings(Settings newSettings) async {
    //Find the existing settings
    final existingSettings = await _settingsStore.findFirst(_database);
    //Get a reference to the record with the settings key
    final recordRef = _settingsStore.record(_settingsKey);

    if (existingSettings == null) {
      //Add a new settings record under the key
      await recordRef.add(_database, newSettings.toMap());
    } else {
      //Update the record under the key
      await recordRef.update(_database, newSettings.toMap());
    }
  }
}
