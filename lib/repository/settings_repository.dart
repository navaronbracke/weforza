import 'package:package_info_plus/package_info_plus.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._dao);

  final ISettingsDao _dao;

  Future<Settings> loadApplicationSettings() async {
    final settings = await _dao.readApplicationSettings();

    // Append the app version to the settings.
    final packageInfo = await PackageInfo.fromPlatform();

    return Settings(
      appVersion: packageInfo.version,
      memberListFilter: settings.memberListFilter,
      scanDuration: settings.scanDuration,
    );
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _dao.writeApplicationSettings(settings);
  }
}
