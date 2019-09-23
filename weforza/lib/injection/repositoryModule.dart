import 'package:dependencies/dependencies.dart';
import 'package:weforza/repository/personRepository.dart';

///This class will provide our repositories.
class RepositoryModule implements Module {

  @override
  void configure(Binder binder) {
    //Note: ALWAYS specify type parameter <T>. Otherwise the factory registers a concrete type.
    binder.bindLazySingleton<IPersonRepository>((injector,params) => PersonRepository());
  }

}