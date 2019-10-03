import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:weforza/blocs/addPersonBloc.dart';
import 'package:weforza/blocs/personListBloc.dart';
import 'package:weforza/blocs/personSelectBloc.dart';
import 'package:weforza/repository/personRepository.dart';

///This class will provide dependencies.
class InjectionContainer {
  static Injector _injector;

  ///Initialize an [Injector] for production
  static void initProductionInjector(){
    _injector = Injector.getInjector();
    //repositories
    _injector.map<IPersonRepository>((i) => PersonRepository(),isSingleton: true);
    //blocs
    _injector.map<PersonListBloc>((i) => PersonListBloc(i.get<IPersonRepository>()));
    _injector.map<PersonSelectBloc>((i) => PersonSelectBloc(),isSingleton: true);
    _injector.map<AddPersonBloc>((i) => AddPersonBloc(i.get<IPersonRepository>()));
    //other
  }

  ///Initialize an [Injector] for testing
  static void initTestInjector(){
    _injector = Injector.getInjector();
    //repositories
    _injector.map<IPersonRepository>((i) => PersonRepository(),isSingleton: true);
    //blocs
    _injector.map<PersonListBloc>((i) => PersonListBloc(i.get<IPersonRepository>()));
    _injector.map<PersonSelectBloc>((i) => PersonSelectBloc(),isSingleton: true);
    _injector.map<AddPersonBloc>((i) => AddPersonBloc(i.get<IPersonRepository>()));
  }

  ///Get a dependency of type [T].
  ///[_injector] shouldn't be null.
  static T get<T>(){
    assert(_injector != null);
    return _injector.get<T>();
  }
}