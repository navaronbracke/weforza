
import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/settings.dart';

///This class defines a contract for managing application settings.
abstract class ISettingsDao {

  ///Read the [Settings] from the database.
  ///If this application never had its settings changed, this returns a
  Future<Settings> readApplicationSettings();

  Future<void> writeApplicationSettings(Settings newSettings);
}

class SettingsDao implements ISettingsDao {
  SettingsDao(this._database, this._settingsStore):
        assert(_database != null && _settingsStore != null);

  SettingsDao.withProvider(ApplicationDatabase provider):
        this(provider.getDatabase(), provider.settingsStore);

  ///The key for the settings record.
  final _settingsKey = "APPLICATION_SETTINGS";

  ///A reference to the database.
  final Database _database;
  ///A reference to the [Settings] store.
  final StoreRef<String, Map<String, dynamic>> _settingsStore;

  @override
  Future<Settings> readApplicationSettings() async {
    final settingsRecord = await _settingsStore.findFirst(_database);
    return settingsRecord == null ? Settings(): Settings.of(settingsRecord.value);
  }

  @override
  Future<void> writeApplicationSettings(Settings newSettings) async {
    //Find the existing settings
    final existingSettings = await _settingsStore.findFirst(_database);
    //Get a reference to the record with the settings key
    final recordRef = _settingsStore.record(_settingsKey);

    if(existingSettings == null){
      //Add a new settings record under the key
      await recordRef.add(_database, newSettings.toMap());
    }else{
      //Update the record under the key
      await recordRef.update(_database, newSettings.toMap());
    }
  }
}