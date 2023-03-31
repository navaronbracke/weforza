import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';

/// This class represents the repository that manages the rides.
class RideRepository {
  RideRepository(this._dao);

  final IRideDao _dao;

  Future<void> addRides(List<Ride> rides) => _dao.addRides(rides);

  Future<void> deleteRide(DateTime date) => _dao.deleteRide(date);

  Future<void> deleteRideCalendar() => _dao.deleteRideCalendar();

  Stream<int> getRideCount() => _dao.getRideCount();

  Future<List<Ride>> getRides() => _dao.getRides();

  Future<List<DateTime>> getRideDates() => _dao.getRideDates();

  Future<void> updateRide(Ride ride, List<RideAttendee> attendees) {
    return _dao.updateRide(ride, attendees);
  }

  Future<List<Member>> getRideAttendees(DateTime date) {
    return _dao.getRideAttendees(date);
  }

  Future<List<ScannedRideAttendee>> getRideAttendeesAsScanResults(
    DateTime date,
  ) {
    return _dao.getRideAttendeesAsScanResults(date);
  }
}
