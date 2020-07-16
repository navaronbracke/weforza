
import 'package:weforza/database/settingsDao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._dao): assert(_dao != null);

  final ISettingsDao _dao;

  Settings _instance;

  Future<Settings> loadApplicationSettings() async {
    if(_instance == null){
      _instance = await _dao.readApplicationSettings();
    }
    return _instance;
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _dao.writeApplicationSettings(settings);
    _instance = settings;
  }
}