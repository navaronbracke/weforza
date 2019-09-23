import 'package:dependencies/dependencies.dart';
import 'package:weforza/blocs/personListBloc.dart';
import 'package:weforza/repository/personRepository.dart';

///This class will provide our BLoC objects.
class BlocModule implements Module {

  @override
  void configure(Binder binder) {
    binder.bindLazySingleton((injector,params) => PersonListBloc(injector.get<IPersonRepository>()));
    //more BLoCs
  }

}