
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/ride.dart';

///This interface defines a contract for manipulating [Ride]s.
abstract class IRideRepository {
  Future<List<Ride>> getAllRides();

  Future addRide(Ride ride);

  Future<bool> checkIfExists(DateTime date);

  Future editRide(Ride ride);

  Future deleteRide(int id);
}

///This class will manage the rides when in a production setting.
class RideRepository implements IRideRepository {
  RideRepository(this._dao): assert(_dao != null);
  final RideDao _dao;

  @override
  Future addRide(Ride ride) async {
    await _dao.addRide(ride);
  }

  @override
  Future<bool> checkIfExists(DateTime date) {
    // TODO: implement checkIfExists
    return null;
  }

  @override
  Future deleteRide(int id) {
    // TODO: implement deleteRide
    return null;
  }

  @override
  Future editRide(Ride ride) {
    // TODO: implement editRide
    return null;
  }

  @override
  Future<List<Ride>> getAllRides() {
    return _dao.getRides();
  }

}

///This class is a test version of [IRideRepository].
class TestRideRepository implements IRideRepository {

  final List<Ride> _list = List();

  @override
  Future addRide(Ride ride) {
    _list.add(ride);
    return null;
  }

  @override
  Future<bool> checkIfExists(DateTime date) {
    return Future.value(_list.firstWhere((r)=> r.date == date,orElse: null) != null);
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