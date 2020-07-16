
import 'package:weforza/database/settingsDao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._dao): assert(_dao != null);

  final ISettingsDao _dao;

  Settings instance;

  Future<Settings> loadApplicationSettings() async {
    if(instance == null){
      instance = await _dao.readApplicationSettings();
    }
    return instance;
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _dao.writeApplicationSettings(settings);
    instance = settings;
  }
}