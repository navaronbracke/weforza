import 'package:weforza/injection/type_factory.dart';

/// This class will provide a Dependency Injection mechanism.
///
/// The internal implementation relies on the use of [runtimeType].
/// Thus you should not override this getter.
/// (Overriding this would be weird anyway)
class Injector {

  /// The collection of types that are mapped to creator functions.
  ///
  /// As the map that collects the factories needs to be able to store any type,
  /// we have to use Object as upper bound.
  ///
  /// At runtime we 'can' assume that types will be correct.
  /// This only fails if the runtime type of the key
  /// isn't the same as the runtime type of the creator function's generic type.
  /// This is however a programmer error, if it occurs.
  final Map<Type, TypeFactory<Object>> _factories = {};

  Injector();

  /// Register a given type creator function.
  /// Throws an [ArgumentError] if the type has already been registered.
  Injector register<T>(CreatorFunction<T> creator, {bool isSingleton = false}) {
    if (_factories.containsKey(T)) {
      throw ArgumentError(
        "The type $T already has a registered creator function",
      );
    }

    _factories[T] = TypeFactory<T>(creator, isSingleton) as TypeFactory<Object>;

    return this;
  }

  /// Get an instance of [T].
  /// Throws an [ArgumentError] if [T] has no registered creator function,
  /// or if the registered creator function does not return an instance of [T].
  T get<T>() {
    final factory = _factories[T];

    if(factory == null){
      throw ArgumentError(
        "There is no registered creator function for type $T",
      );
    }

    try {
      return factory.creatorFunction(this) as T;
    }catch (TypeError){
      throw ArgumentError(
        "The registered creator function for type $T did not return an instance of $T",
      );
    }
  }

  /// Disposes of the injector singleton.
  void dispose() {
    _factories.clear();
  }
}