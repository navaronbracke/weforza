
import 'package:weforza/model/ride.dart';

///This interface defines a contract for manipulating [Ride]s.
abstract class IRideRepository {
  Future<List<Ride>> getAllRides();
}

///This class will manage the rides when in a production setting.
class RideRepository implements IRideRepository {
  @override
  Future<List<Ride>> getAllRides() {
    // TODO: implement getAllRides
    return Future.value(List.of([Ride(DateTime.now(),List())]));
  }

}

///This class is a test version of [IRideRepository].
class TestRideRepository implements IRideRepository {
  @override
  Future<List<Ride>> getAllRides() {
    return Future.value(List.of([Ride(DateTime(2000),List())]));
  }

}