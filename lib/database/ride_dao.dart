import 'package:sembast/sembast.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/model/rider/rider.dart';

/// This class represents the interface for working with [Ride]s from the [Database].
abstract interface class RideDao {
  /// Add the given [rides].
  Future<void> addRides(List<Ride> rides);

  /// Delete the ride with the given [date].
  Future<void> deleteRide(DateTime date);

  /// Delete the entire ride calendar.
  Future<void> deleteRideCalendar();

  /// Get the attendees of the ride with the given [date].
  Future<List<Rider>> getRideAttendees(DateTime date, {required FileUriParser fileUriParser});

  /// Get the dates of the rides in the calendar.
  Future<List<DateTime>> getRideDates();

  /// Get the list of rides.
  Future<List<Ride>> getRides();

  /// Get the amount of rides in the calendar.
  Future<int> getRidesCount();

  /// Get the attendees of the ride with the given [date], as scan results.
  Future<List<ScannedRideAttendee>> getScanResults(DateTime date);

  /// Update the given [ride] and its [attendees].
  Future<void> updateRide(Ride ride, List<RideAttendee> attendees);

  /// Get a stream of changes to the amount of rides.
  Stream<int> watchRidesCount();
}
