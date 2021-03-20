import 'package:weforza/injection/injector.dart';

typedef CreatorFunction<T> = T Function(Injector injector);

/// This type factory will create instances of provided types.
class TypeFactory<T> {
  TypeFactory(this.creatorFunction, [this.isSingleton = false]);

  /// Whether the instance
  /// that is created by [creatorFunction] should be a singleton.
  final bool isSingleton;

  /// The creator function that will create the provided instance.
  final CreatorFunction<T> creatorFunction;

  /// The internal instance.
  T? _instance;

  /// Get an instance of the required type.
  T get(Injector injector) {
    /// If provided as a singleton, return it.
    if (isSingleton && _instance != null) {
      return _instance!;
    }

    final instance = creatorFunction(injector);

    /// Set up the singleton, if required.
    if (isSingleton) {
      _instance = instance;
    }

    return instance;
  }
}