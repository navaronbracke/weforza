import 'package:file/local.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_factory.dart';
import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_members_dao.dart';
import 'package:weforza/database/member_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/exportMembersRepository.dart';
import 'package:weforza/repository/exportRidesRepository.dart';
import 'package:weforza/repository/importMembersRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';

///This class will provide dependencies.
class InjectionContainer {
  // We assume that the injector is set
  // somewhere in the main function but before the app runs.
  static late Injector _injector;

  ///Initialize an [Injector] for production.
  ///Note that this is an async function,since we initialize a production database.
  static Future<void> initProductionInjector() async {
    //Only now we configure the injector itself.
    _injector = Injector();

    //database
    _injector.register<ApplicationDatabase>((i) => ApplicationDatabase(),
        isSingleton: true);
    //We need a reference to the database provider for passing the database/stores to the Dao instances.
    final ApplicationDatabase applicationDatabase =
        _injector.get<ApplicationDatabase>();

    _injector.register<IMemberDao>(
        (i) => MemberDao.withProvider(applicationDatabase),
        isSingleton: true);
    _injector.register<IRideDao>(
        (i) => RideDao.withProvider(applicationDatabase),
        isSingleton: true);
    _injector.register<IDeviceDao>(
        (i) => DeviceDao.withProvider(applicationDatabase),
        isSingleton: true);
    _injector.register<ISettingsDao>(
        (i) => SettingsDao.withProvider(applicationDatabase),
        isSingleton: true);
    _injector.register<IImportMembersDao>(
        (i) => ImportMembersDao.withProvider(applicationDatabase),
        isSingleton: true);
    _injector.register<IExportRidesDao>(
        (i) => ExportRidesDao.withProvider(applicationDatabase),
        isSingleton: true);

    //repositories
    _injector.register<MemberRepository>(
        (i) => MemberRepository(i.get<IMemberDao>()),
        isSingleton: true);
    _injector.register<RideRepository>((i) => RideRepository(i.get<IRideDao>()),
        isSingleton: true);
    _injector.register<DeviceRepository>(
        (i) => DeviceRepository(i.get<IDeviceDao>()),
        isSingleton: true);
    _injector.register<SettingsRepository>(
        (i) => SettingsRepository(i.get<ISettingsDao>()),
        isSingleton: true);
    _injector.register<ImportMembersRepository>(
        (i) => ImportMembersRepository(i.get<IImportMembersDao>()),
        isSingleton: true);
    _injector.register<ExportRidesRepository>(
        (i) => ExportRidesRepository(i.get<IExportRidesDao>()),
        isSingleton: true);
    _injector.register<ExportMembersRepository>(
        (i) =>
            ExportMembersRepository(i.get<IDeviceDao>(), i.get<IMemberDao>()),
        isSingleton: true);

    //file handler
    _injector.register<IFileHandler>((i) => FileHandler(), isSingleton: true);
    //bluetooth scanner
    _injector.register<BluetoothDeviceScanner>(
        (i) => BluetoothDeviceScannerImpl(),
        isSingleton: true);

    //other

    // After setting up the dependency tree, we can initialize the production database.
    // Provide the database factory that uses actual File I/O.
    await applicationDatabase.openDatabase(
      ApplicationDatabaseFactory(
        factory: databaseFactoryIo,
        fileSystem: const LocalFileSystem(),
      ),
    );
  }

  ///Initialize an [Injector] for testing.
  ///This one doesn't add anything, so we can add stuff on demand during tests.
  static Future<void> initTestInjector() async {
    _injector = Injector();
  }

  ///Get a dependency of type [T].
  static T get<T>() {
    return _injector.get<T>();
  }

  static void dispose() {
    _injector.dispose();
  }
}
