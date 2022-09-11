import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._settingsDao);

  final SettingsDao _settingsDao;

  Future<Settings> read() => _settingsDao.read();

  Future<void> write(Settings settings) => _settingsDao.write(settings);
}
