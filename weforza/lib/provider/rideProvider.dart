import 'package:weforza/model/ride.dart';

///This class provides a global container for a selected [Ride] and a reload flag for loading [Ride]s from a datasource.
class RideProvider {
  ///This flag guards the load of [Ride].
  ///A load can only happen if this flag got set to true with its setter.
  ///Upon calling its getter, it gets reset.
  ///We start the flag on true, since we want the initial data to load without the setter having been called.
  static bool _shouldReloadRides = true;

  ///Get the ride reload flag's value.
  ///Calling this getter resets the value to false.
  static bool get reloadRides {
    bool oldValue = _shouldReloadRides;
    _shouldReloadRides = false;
    return oldValue;
  }

  ///Set [_shouldReloadRides] to a new value.
  static set reloadRides(bool value){
    _shouldReloadRides = value;
  }

  ///A selected [Ride] is stored here.
  static Ride selectedRide;
}