import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:weforza/blocs/addMemberBloc.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/blocs/memberListBloc.dart';
import 'package:weforza/blocs/memberSelectBloc.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class will provide dependencies.
class InjectionContainer {
  ///The [Injector] itself.
  static Injector _injector;

  ///Initialize an [Injector] for production.
  static void initProductionInjector(){
    _injector = Injector.getInjector();
    //repositories
    _injector.map<IMemberRepository>((i) => MemberRepository(),isSingleton: true);
    //blocs
    _injector.map<MemberListBloc>((i) => MemberListBloc(i.get<IMemberRepository>()));
    _injector.map<MemberSelectBloc>((i) => MemberSelectBloc(),isSingleton: true);
    _injector.map<AddMemberBloc>((i) => AddMemberBloc(i.get<IMemberRepository>()));
    _injector.map<MemberDetailsBloc>((i) => MemberDetailsBloc(i.get<MemberSelectBloc>().selectedMember));
    _injector.map<RideListBloc>((i) => RideListBloc());
    //other
  }

  ///Initialize an [Injector] for testing.
  static void initTestInjector(){
    _injector = Injector.getInjector();
    //repositories
    _injector.map<IMemberRepository>((i) => MemberRepository(),isSingleton: true);
    //blocs
    _injector.map<MemberListBloc>((i) => MemberListBloc(i.get<IMemberRepository>()));
    _injector.map<MemberSelectBloc>((i) => MemberSelectBloc(),isSingleton: true);
    _injector.map<AddMemberBloc>((i) => AddMemberBloc(i.get<IMemberRepository>()));
    _injector.map<RideListBloc>((i) => RideListBloc());
  }

  ///Get a dependency of type [T].
  ///[_injector] shouldn't be null.
  static T get<T>(){
    assert(_injector != null);
    return _injector.get<T>();
  }
}