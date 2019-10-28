
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/ride.dart';

///This interface defines a contract for manipulating [Ride]s.
abstract class IRideRepository {
  ///Get all rides.
  Future<List<Ride>> getAllRides();

  Future addRides(List<Ride> rides);

  ///Edit a given ride.
  Future editRide(Ride ride);

  ///Delete a given ride.
  Future deleteRide(int id);
}

///This class will manage the rides when in a production setting.
class RideRepository implements IRideRepository {
  RideRepository(this._dao): assert(_dao != null);
  ///The internal DAO instance.
  final RideDao _dao;

  ///See [IRideRepository].
  @override
  Future addRides(List<Ride> rides) => _dao.addRides(rides);

  ///See [IRideRepository].
  @override
  Future deleteRide(int id) => _dao.deleteRide(id);

  ///See [IRideRepository].
  @override
  Future editRide(Ride ride) => _dao.editRide(ride);

  ///See [IRideRepository].
  @override
  Future<List<Ride>> getAllRides() => _dao.getRides();

}

///This class is a test version of [IRideRepository].
class TestRideRepository implements IRideRepository {

  final List<Ride> _list = List();

  @override
  Future addRides(List<Ride> rides) {
    _list.addAll(rides);
    return null;
  }

  @override
  Future deleteRide(int id) {
    _list.removeWhere((r) => r.id == id);
    return null;
  }

  @override
  Future editRide(Ride ride) {
    if(ride != null){
      Ride r = _list.firstWhere((r)=> r.id == ride.id,orElse: null);
      if(r != null){
        r.attendees.clear();
        r.attendees.addAll(ride.attendees);
      }
    }
    return null;
  }

  @override
  Future<List<Ride>> getAllRides() {
    return Future.value(_list);
  }



}