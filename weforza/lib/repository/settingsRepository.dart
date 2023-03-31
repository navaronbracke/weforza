
import 'package:package_info/package_info.dart';
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
      //Read the application package info as well
      instance.packageInfo = await PackageInfo.fromPlatform();
    }
  }

  Future<void> writeApplicationSettings(Settings settings) async {
    final packageInfo = instance.packageInfo;
    await _dao.writeApplicationSettings(settings);
    instance = settings;
    //Don't forget to reparent the package info
    instance.packageInfo = packageInfo;
  }
}