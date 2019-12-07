import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:weforza/database/databaseProvider.dart';
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
    _injector.map<MemberDao>((i) => MemberDao(DatabaseProvider.getDatabase()),isSingleton: true);
    _injector.map<RideDao>((i) => RideDao(DatabaseProvider.getDatabase()),isSingleton: true);
    //repositories
    _injector.map<IMemberRepository>((i) => MemberRepository(i.get<MemberDao>()),isSingleton: true);
    _injector.map<IRideRepository>((i) => RideRepository(i.get<RideDao>()),isSingleton: true);
    //other
  }

  ///Initialize an [Injector] for testing.
  static void initTestInjector(){
    _injector = Injector.getInjector();

    //repositories
    _injector.map<IMemberRepository>((i) => TestMemberRepository(),isSingleton: true);
    _injector.map<IRideRepository>((i) => TestRideRepository(),isSingleton: true);
  }

  ///Get a dependency of type [T].
  ///[_injector] shouldn't be null.
  static T get<T>(){
    assert(_injector != null);
    return _injector.get<T>();
  }
}