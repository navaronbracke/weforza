import 'package:package_info_plus/package_info_plus.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._settingsDao);

  final ISettingsDao _settingsDao;

  Future<Settings> loadApplicationSettings(int ridesCount) async {
    final packageInfo = await PackageInfo.fromPlatform();

    return _settingsDao.readApplicationSettings(
      packageInfo.version,
      ridesCount > 0,
    );
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _settingsDao.writeApplicationSettings(settings);
  }
}
