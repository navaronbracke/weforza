
import 'package:package_info/package_info.dart';
import 'package:weforza/database/settingsDao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._dao);

  final ISettingsDao _dao;

  Future<Settings> loadApplicationSettings() async {
    final settings = await _dao.readApplicationSettings();

    // Append the package info to the settings.
    settings.packageInfo = await PackageInfo.fromPlatform();

    return settings;
  }

  Future<void> writeApplicationSettings(Settings settings)
    => _dao.writeApplicationSettings(settings);
}