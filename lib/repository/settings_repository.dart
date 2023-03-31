import 'package:package_info_plus/package_info_plus.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/model/settings.dart';

class SettingsRepository {
  SettingsRepository(this._rideDao, this._settingsDao);

  final IRideDao _rideDao;

  final ISettingsDao _settingsDao;

  Future<Settings> loadApplicationSettings() async {
    final ridesCount = await _rideDao.getRidesCount();
    final settings = await _settingsDao.readApplicationSettings();
    final packageInfo = await PackageInfo.fromPlatform();

    return Settings(
      appVersion: packageInfo.version,
      hasRideCalendar: ridesCount > 0,
      memberListFilter: settings.memberListFilter,
      scanDuration: settings.scanDuration,
    );
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    await _settingsDao.writeApplicationSettings(settings);
  }
}
