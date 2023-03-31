import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/deviceDao.dart';
import 'package:weforza/database/exportRidesDao.dart';
import 'package:weforza/database/importMembersDao.dart';
import 'package:weforza/database/memberDao.dart';
import 'package:weforza/database/rideDao.dart';
import 'package:weforza/database/settingsDao.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/exportRidesRepository.dart';
import 'package:weforza/repository/importMembersRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';

///This class will provide dependencies.
class InjectionContainer {
  ///The [Injector] itself.
  static Injector _injector;

  ///Initialize an [Injector] for production.
  ///Note that this is an async function,since we initialize a production database.
  static Future<void> initProductionInjector() async {
    //Only now we configure the injector itself.
    _injector = Injector.getInjector();
    //database
    _injector.map<ApplicationDatabase>((i) => ApplicationDatabase(),isSingleton: true);
    //We need a reference to the database provider for passing the database/stores to the Dao instances.
    final ApplicationDatabase applicationDatabase = _injector.get<ApplicationDatabase>();
    
    _injector.map<IMemberDao>((i) => MemberDao.withProvider(i.get<ApplicationDatabase>()),isSingleton: true);
    _injector.map<IRideDao>((i) => RideDao.withProvider(i.get<ApplicationDatabase>()),isSingleton: true);
    _injector.map<IDeviceDao>((i)=> DeviceDao.withProvider(i.get<ApplicationDatabase>()),isSingleton: true);
    _injector.map<ISettingsDao>((i) => SettingsDao.withProvider(i.get<ApplicationDatabase>()),isSingleton: true);
    _injector.map<IImportMembersDao>((i) => ImportMembersDao.withProvider(i.get<ApplicationDatabase>()),isSingleton: true);
    _injector.map<IExportRidesDao>((i) => ExportRidesDao.withProvider(i.get<ApplicationDatabase>()), isSingleton: true);
    //repositories
    _injector.map<MemberRepository>((i) => MemberRepository(i.get<IMemberDao>(),i.get<IFileHandler>()),isSingleton: true);
    _injector.map<RideRepository>((i) => RideRepository(i.get<IRideDao>()),isSingleton: true);
    _injector.map<DeviceRepository>((i)=> DeviceRepository(i.get<IDeviceDao>()),isSingleton: true);
    _injector.map<SettingsRepository>((i)=> SettingsRepository(i.get<ISettingsDao>()),isSingleton: true);
    _injector.map<ImportMembersRepository>((i) => ImportMembersRepository(i.get<IImportMembersDao>()),isSingleton: true);
    _injector.map<ExportRidesRepository>((i) => ExportRidesRepository(i.get<IExportRidesDao>()),isSingleton: true);

    //file handler
    _injector.map<IFileHandler>((i) => FileHandler(),isSingleton: true);
    //bluetooth scanner
    _injector.map<BluetoothDeviceScanner>((i) => BluetoothDeviceScannerImpl(),isSingleton: true);

    //other

    //After setting up the dependency tree, we can initialize the production database.
    await applicationDatabase.createDatabase();
  }

  ///Initialize an [Injector] for testing.
  ///This one doesn't add anything, so we can add stuff on demand during tests.
  static Future<void> initTestInjector() async {
    _injector = Injector.getInjector();
  }

  ///Get a dependency of type [T].
  ///[_injector] shouldn't be null.
  static T get<T>(){
    assert(_injector != null);
    return _injector.get<T>();
  }
}