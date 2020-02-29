
import 'package:weforza/database/settingsDao.dart';
import 'package:weforza/model/settings/settings.dart';

class SettingsRepository {
  SettingsRepository(this._dao): assert(_dao != null);

  final ISettingsDao _dao;

  Future<void> loadApplicationSettings() async {
    Settings.updateSettings(await _dao.readApplicationSettings());
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _dao.writeApplicationSettings(settings);
    Settings.updateSettings(settings);
  }
}