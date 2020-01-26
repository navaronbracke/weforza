import 'package:weforza/model/ride.dart';

///This class provides a global container for a selected [Ride] and a reload flag for loading [Ride]s from a datasource.
class RideProvider {

  ///Whether we should reload the rides.
  static bool reloadRides = true;

  ///A selected [Ride] is stored here.
  static Ride selectedRide;
}