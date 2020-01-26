
import 'package:weforza/database/rideDao.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';

///This class will manage the rides.
class RideRepository {
  RideRepository(this._dao): assert(_dao != null);
  ///The internal DAO instance.
  final RideDao _dao;

  Future<void> addRides(List<Ride> rides) => _dao.addRides(rides);

  Future<void> deleteRide(DateTime date) => _dao.deleteRide(date);

  Future<void> deleteAllRides() => _dao.deleteAllRides();

  Future<List<Ride>> getRides() => _dao.getRides();

  Future<List<DateTime>> getRideDates() => _dao.getRideDates();

  Future<void> updateAttendeesForRideWithDate(Ride ride, List<RideAttendee> attendees) => _dao.updateAttendeesForRideWithDate(ride, attendees);
}