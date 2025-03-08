import 'package:sembast/sembast.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/sembast/database_tables.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/model/rider/rider.dart';

/// This class represents the sembast implementation of [RideDao].
class SembastRideDao implements RideDao {
  SembastRideDao(this._database);

  /// A reference to the database.
  final Database _database;

  /// A reference to the [Rider] store.
  final _riderStore = DatabaseTables.rider;

  /// A reference to the [RideAttendee] store.
  final _rideAttendeeStore = DatabaseTables.rideAttendee;

  /// A reference to the [Ride] store.
  final _rideStore = DatabaseTables.ride;

  @override
  Future<void> addRides(List<Ride> rides) async {
    final records = _rideStore.records(rides.map((r) => r.date.toIso8601String()).toList());

    await records.put(_database, rides.map((r) => r.toMap()).toList());
  }

  @override
  Future<void> deleteRide(DateTime date) {
    final isoDate = date.toIso8601String();

    return _database.transaction((txn) async {
      await _rideAttendeeStore.delete(txn, finder: Finder(filter: Filter.equals('date', isoDate)));

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
  Future<List<Rider>> getRideAttendees(DateTime date, {required FileUriParser fileUriParser}) async {
    final rideAttendees = await _rideAttendeeStore.find(
      _database,
      finder: Finder(filter: Filter.equals('date', date.toIso8601String())),
    );

    final attendeeIds = rideAttendees.map((r) => r.value['attendee']).toList();

    final riderRecords = await _riderStore.find(
      _database,
      finder: Finder(
        filter: Filter.custom((record) => attendeeIds.contains(record.key)),
        sortOrders: [SortOrder('firstname'), SortOrder('lastname'), SortOrder('alias')],
      ),
    );

    return riderRecords.map((r) => Rider.of(r.key, r.value, fileUriParser: fileUriParser)).toList();
  }

  @override
  Future<List<DateTime>> getRideDates() async {
    final rides = await _rideStore.findKeys(_database);

    return rides.map(DateTime.parse).toList();
  }

  @override
  Future<List<Ride>> getRides() async {
    final records = await _rideStore.find(_database, finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

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
    final rideAttendeeFinder = Finder(filter: Filter.equals('date', rideRecordKey));

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
