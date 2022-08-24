import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._settingsDao);

  final ISettingsDao _settingsDao;

  Future<Settings> loadApplicationSettings() {
    return _settingsDao.readApplicationSettings();
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _settingsDao.writeApplicationSettings(settings);
  }
}
