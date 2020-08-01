
import 'package:weforza/database/settingsDao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._dao): assert(_dao != null);

  final ISettingsDao _dao;

  Settings instance;

  bool get shouldLoadSettings => instance == null;

  Future<void> loadApplicationSettings() async {
    if(shouldLoadSettings){
      instance = await _dao.readApplicationSettings();
    }
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _dao.writeApplicationSettings(settings);
    instance = settings;
  }
}