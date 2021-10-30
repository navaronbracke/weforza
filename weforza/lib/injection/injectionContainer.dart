import 'package:file/local.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/cipher/cipher.dart';
import 'package:weforza/cipher/data_cipher.dart';
import 'package:weforza/database/databaseFactory.dart';
import 'package:weforza/database/database_migration.dart';
import 'package:weforza/database/database_store_provider.dart';
import 'package:weforza/injection/injector.dart';
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
import 'package:weforza/repository/exportMembersRepository.dart';
import 'package:weforza/repository/exportRidesRepository.dart';
import 'package:weforza/repository/importMembersRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:dotenv/dotenv.dart' show load, env;

///This class will provide dependencies.
class InjectionContainer {
  // We assume that the injector is set
  // somewhere in the main function but before the app runs.
  static late Injector _injector;

  ///Initialize an [Injector] for production.
  ///Note that this is an async function,since we initialize a production database.
  static Future<void> initProductionInjector() async {
    load(); // Load env vars.

    //Only now we configure the injector itself.
    _injector = Injector();
    _injector.register<Cipher>((i){
      return DataCipher(
        encryptionKey: env["ENCRYPTION_KEY"]!,
        encryptionSalt: env["ENCRYPTION_SALT"]!
      );
    });

    //database
    _injector.register<ApplicationDatabase>((i) => ApplicationDatabase(), isSingleton: true);
    //We need a reference to the database provider for passing the database/stores to the Dao instances.
    final ApplicationDatabase applicationDatabase = _injector.get<ApplicationDatabase>();
    final storeProvider = DatabaseStoreProvider();

    _injector.register<IMemberDao>((i) => MemberDao.withProvider(applicationDatabase.getDatabase(), storeProvider, i.get<Cipher>()),isSingleton: true);
    _injector.register<IRideDao>((i) => RideDao.withProvider(applicationDatabase.getDatabase(), storeProvider, i.get<Cipher>()),isSingleton: true);
    _injector.register<IDeviceDao>((i)=> DeviceDao.withProvider(applicationDatabase.getDatabase(), storeProvider, i.get<Cipher>()),isSingleton: true);
    _injector.register<ISettingsDao>((i) => SettingsDao.withProvider(applicationDatabase.getDatabase(), storeProvider),isSingleton: true);
    _injector.register<IImportMembersDao>((i) => ImportMembersDao.withProvider(applicationDatabase.getDatabase(), storeProvider, i.get<Cipher>()),isSingleton: true);
    _injector.register<IExportRidesDao>((i) => ExportRidesDao.withProvider(applicationDatabase.getDatabase(), storeProvider, i.get<Cipher>()), isSingleton: true);

    //repositories
    _injector.register<MemberRepository>((i) => MemberRepository(i.get<IMemberDao>()),isSingleton: true);
    _injector.register<RideRepository>((i) => RideRepository(i.get<IRideDao>()),isSingleton: true);
    _injector.register<DeviceRepository>((i)=> DeviceRepository(i.get<IDeviceDao>()),isSingleton: true);
    _injector.register<SettingsRepository>((i)=> SettingsRepository(i.get<ISettingsDao>()),isSingleton: true);
    _injector.register<ImportMembersRepository>((i) => ImportMembersRepository(i.get<IImportMembersDao>()),isSingleton: true);
    _injector.register<ExportRidesRepository>((i) => ExportRidesRepository(i.get<IExportRidesDao>()),isSingleton: true);
    _injector.register<ExportMembersRepository>((i) => ExportMembersRepository(i.get<IDeviceDao>(),i.get<IMemberDao>()),isSingleton: true);

    //file handler
    _injector.register<IFileHandler>((i) => FileHandler(),isSingleton: true);
    //bluetooth scanner
    _injector.register<BluetoothDeviceScanner>((i) => BluetoothDeviceScannerImpl(),isSingleton: true);

    //other

    // After setting up the dependency tree, we can initialize the production database.
    // Provide the database factory that uses actual File I/O.
    await applicationDatabase.openDatabase(
      ApplicationDatabaseFactory(
        factory: databaseFactoryIo,
        fileSystem: const LocalFileSystem(),
      ),
      DatabaseMigration(
        encryptingCipher: _injector.get<Cipher>(),
        storeProvider: storeProvider,
      ),
    );
  }

  ///Initialize an [Injector] for testing.
  ///This one doesn't add anything, so we can add stuff on demand during tests.
  static Future<void> initTestInjector() async {
    _injector = Injector();
  }

  ///Get a dependency of type [T].
  static T get<T>(){
    return _injector.get<T>();
  }

  static void dispose(){
    _injector.dispose();
  }
}