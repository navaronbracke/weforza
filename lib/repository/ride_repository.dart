import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/model/rider/rider.dart';

/// This class represents the repository that manages the rides.
class RideRepository {
  RideRepository(this._dao, this._fileUriParser);

  final RideDao _dao;

  final FileUriParser _fileUriParser;

  Future<void> addRides(List<Ride> rides) => _dao.addRides(rides);

  Future<void> deleteRide(DateTime date) => _dao.deleteRide(date);

  Future<void> deleteRideCalendar() => _dao.deleteRideCalendar();

  Future<List<Rider>> getRideAttendees(DateTime date) {
    return _dao.getRideAttendees(date, fileUriParser: _fileUriParser);
  }

  Future<List<DateTime>> getRideDates() => _dao.getRideDates();

  Future<List<Ride>> getRides() => _dao.getRides();

  Future<int> getRidesCount() => _dao.getRidesCount();

  Future<List<ScannedRideAttendee>> getScanResults(DateTime date) {
    return _dao.getScanResults(date);
  }

  Future<void> updateRide(Ride ride, List<RideAttendee> attendees) {
    return _dao.updateRide(ride, attendees);
  }

  Stream<int> watchRidesCount() => _dao.watchRidesCount();
}
