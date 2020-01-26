import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/database/deviceDao.dart';
import 'package:weforza/database/memberDao.dart';
import 'package:weforza/database/rideDao.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class will provide dependencies.
class InjectionContainer {
  ///The [Injector] itself.
  static Injector _injector;

  ///Initialize an [Injector] for production.
  ///Note that this is an async function,since we initialize a production database.
  static Future initProductionInjector() async {
    //Initialize the production database.
    await DatabaseProvider.initializeDatabase();
    //Only now we configure the injector itself.
    _injector = Injector.getInjector();
    //database
    _injector.map<IMemberDao>((i) => MemberDao(DatabaseProvider.getDatabase()),isSingleton: true);
    _injector.map<IRideDao>((i) => RideDao(DatabaseProvider.getDatabase()),isSingleton: true);
    _injector.map<IDeviceDao>((i)=> DeviceDao(DatabaseProvider.getDatabase()),isSingleton: true);
    //repositories
    _injector.map<MemberRepository>((i) => MemberRepository(i.get<IMemberDao>(),i.get<IFileHandler>()),isSingleton: true);
    _injector.map<RideRepository>((i) => RideRepository(i.get<IRideDao>()),isSingleton: true);
    _injector.map<DeviceRepository>((i)=> DeviceRepository(i.get<IDeviceDao>()),isSingleton: true);
    //file handler
    _injector.map<IFileHandler>((i) => FileHandler(),isSingleton: true);
    //other
  }

  ///Initialize an [Injector] for testing.
  static void initTestInjector(){
    _injector = Injector.getInjector();
  }

  ///Get a dependency of type [T].
  ///[_injector] shouldn't be null.
  static T get<T>(){
    assert(_injector != null);
    return _injector.get<T>();
  }
}