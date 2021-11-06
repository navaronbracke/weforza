
import 'package:package_info/package_info.dart';
import 'package:weforza/database/settingsDao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._dao);

  final ISettingsDao _dao;

  Future<Settings> loadApplicationSettings() async {
    final settings = await _dao.readApplicationSettings();

    // Append the app version to the settings.
    final packageInfo = await PackageInfo.fromPlatform();

    settings.appVersion = packageInfo.version;

    return settings;
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _dao.writeApplicationSettings(settings);
  }
}