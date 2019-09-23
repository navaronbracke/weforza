import 'package:dependencies/dependencies.dart';
import 'package:weforza/injection/blocModule.dart';
import 'package:weforza/injection/repositoryModule.dart';

///This class defines a contract for a custom dependency injector.
abstract class DependencyInjector {
  ///Setup the given [Binder].
  void setup(Binder binder);
}

///This [DependencyInjector] sets up production scope injection.
class ProductionInjector implements DependencyInjector {
  @override
  void setup(Binder binder) {
    binder.install(RepositoryModule());
    binder.install(BlocModule());
    //more modules
  }

}

///This [DependencyInjector] sets up testing scope injection.
class TestInjector implements DependencyInjector {
  @override
  void setup(Binder binder) {
    // TODO: implement setup
    //Need test versions of the required modules
  }
}