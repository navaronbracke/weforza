
import 'package:weforza/database/rideDao.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';

///This class will manage the rides.
class RideRepository {
  RideRepository(this._dao);
  ///The internal DAO instance.
  final IRideDao _dao;

  Future<void> addRides(List<Ride> rides) => _dao.addRides(rides);

  Future<void> deleteRide(DateTime date) => _dao.deleteRide(date);

  Future<void> deleteRideCalendar() => _dao.deleteRideCalendar();

  Future<List<Ride>> getRides() => _dao.getRides();

  Future<List<DateTime>> getRideDates() => _dao.getRideDates();

  Future<void> updateRide(Ride ride, List<RideAttendee> attendees) => _dao.updateRide(ride, attendees);

  Future<List<Member>> getRideAttendees(DateTime date) => _dao.getRideAttendees(date);

  Future<int> getAmountOfRideAttendees(DateTime rideDate) => _dao.getAmountOfRideAttendees(rideDate);
}