import 'package:sembast/sembast.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';

/// This class represents an interface for working with rides.
abstract class RideDao {
  /// Add the given [rides].
  Future<void> addRides(List<Ride> rides);

  /// Delete the ride with the given [date].
  Future<void> deleteRide(DateTime date);

  /// Delete the entire ride calendar.
  Future<void> deleteRideCalendar();

  /// Get the attendees of the ride with the given [date].
  Future<List<Member>> getRideAttendees(DateTime date);

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

/// The default implementation of [RideDao].
class RideDaoImpl implements RideDao {
  RideDaoImpl(this._database, DatabaseTables tables)
      : _memberStore = tables.member,
        _rideAttendeeStore = tables.rideAttendee,
        _rideStore = tables.ride;

  /// A reference to the database.
  final Database _database;

  /// A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;

  /// A reference to the [RideAttendee] store.
  final StoreRef<String, Map<String, dynamic>> _rideAttendeeStore;

  /// A reference to the [Ride] store.
  final StoreRef<String, Map<String, dynamic>> _rideStore;

  @override
  Future<void> addRides(List<Ride> rides) async {
    final records = _rideStore.records(
      rides.map((r) => r.date.toIso8601String()).toList(),
    );

    await records.put(_database, rides.map((r) => r.toMap()).toList());
  }

  @override
  Future<void> deleteRide(DateTime date) {
    final isoDate = date.toIso8601String();

    return _database.transaction((txn) async {
      await _rideAttendeeStore.delete(
        txn,
        finder: Finder(filter: Filter.equals('date', isoDate)),
      );

      await _rideStore.record(isoDate).delete(txn);
    });
  }

  @override
  Future<void> deleteRideCalendar() {
    return _database.transaction((txn) async {
      await _rideAttendeeStore.delete(txn);
      await _rideStore.delete(txn);
    });
  }

  @override
  Future<List<Member>> getRideAttendees(DateTime date) async {
    final rideAttendees = await _rideAttendeeStore.find(
      _database,
      finder: Finder(filter: Filter.equals('date', date.toIso8601String())),
    );

    final attendeeIds = rideAttendees.map((r) => r.value['attendee']).toList();

    final memberRecords = await _memberStore.find(
      _database,
      finder: Finder(
        filter: Filter.custom((record) => attendeeIds.contains(record.key)),
        sortOrders: [
          SortOrder('firstname'),
          SortOrder('lastname'),
          SortOrder('alias'),
        ],
      ),
    );

    return memberRecords.map((r) => Member.of(r.key, r.value)).toList();
  }

  @override
  Future<List<DateTime>> getRideDates() async {
    final rides = await _rideStore.findKeys(_database);

    return rides.map(DateTime.parse).toList();
  }

  @override
  Future<List<Ride>> getRides() async {
    final records = await _rideStore.find(
      _database,
      finder: Finder(sortOrders: [SortOrder(Field.key, false)]),
    );

    return records.map((r) => Ride.of(DateTime.parse(r.key), r.value)).toList();
  }

  @override
  Future<int> getRidesCount() => _rideStore.count(_database);

  @override
  Future<List<ScannedRideAttendee>> getScanResults(DateTime date) async {
    final records = await _rideAttendeeStore.find(
      _database,
      finder: Finder(filter: Filter.equals('date', date.toIso8601String())),
    );

    return records.map((r) => ScannedRideAttendee.of(r.value)).toList();
  }

  @override
  Future<void> updateRide(Ride ride, List<RideAttendee> attendees) {
    // The key for the ride record is the ride date as an ISO 8601 date.
    final rideRecordKey = ride.date.toIso8601String();

    // Find the attendees for the ride.
    final rideAttendeeFinder = Finder(
      filter: Filter.equals('date', rideRecordKey),
    );

    return _database.transaction((txn) async {
      // Update the ride scanned attendees counter in the record.
      await _rideStore.record(rideRecordKey).update(txn, ride.toMap());

      // Delete the old attendees for the ride and insert all the new attendees,
      // which are both the old records and the new records.
      await _rideAttendeeStore.delete(txn, finder: rideAttendeeFinder);
      // Each attendee record uses the ride record key
      // concatenated with the uuid as record key.
      await _rideAttendeeStore
          .records(attendees.map((a) => '$rideRecordKey${a.uuid}'))
          .put(txn, attendees.map((a) => a.toMap()).toList());
    });
  }

  @override
  Stream<int> watchRidesCount() => _rideStore.onCount(_database);
}
