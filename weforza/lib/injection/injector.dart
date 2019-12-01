import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:weforza/blocs/addMemberBloc.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/blocs/memberListBloc.dart';
import 'package:weforza/blocs/memberSelectBloc.dart';
import 'package:weforza/blocs/rideListBloc.dart';
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
    //blocs
    _injector.map<MemberListBloc>((i) => MemberListBloc(i.get<IMemberRepository>()));
    _injector.map<MemberSelectBloc>((i) => MemberSelectBloc(),isSingleton: true);
    _injector.map<AddMemberBloc>((i) => AddMemberBloc(i.get<IMemberRepository>()));
    _injector.map<MemberDetailsBloc>((i) => MemberDetailsBloc(i.get<MemberSelectBloc>().selectedMember,i.get<IMemberRepository>(),i.get<IRideRepository>()));
    _injector.map<RideListBloc>((i) => RideListBloc(i.get<IMemberRepository>(),i.get<IRideRepository>()));
    _injector.map<AddRideBloc>((i) => AddRideBloc(i.get<IRideRepository>()));
    //other
  }

  ///Initialize an [Injector] for testing.
  static void initTestInjector(){
    _injector = Injector.getInjector();

    //repositories
    _injector.map<IMemberRepository>((i) => TestMemberRepository(),isSingleton: true);
    _injector.map<IRideRepository>((i) => TestRideRepository(),isSingleton: true);
    //blocs
    _injector.map<MemberListBloc>((i) => MemberListBloc(i.get<IMemberRepository>()));
    _injector.map<MemberSelectBloc>((i) => MemberSelectBloc(),isSingleton: true);
    _injector.map<AddMemberBloc>((i) => AddMemberBloc(i.get<IMemberRepository>()));
    _injector.map<RideListBloc>((i) => RideListBloc(i.get<IMemberRepository>(),i.get<IRideRepository>()));
    _injector.map<AddRideBloc>((i) => AddRideBloc(i.get<IRideRepository>()));
  }

  ///Get a dependency of type [T].
  ///[_injector] shouldn't be null.
  static T get<T>(){
    assert(_injector != null);
    return _injector.get<T>();
  }
}