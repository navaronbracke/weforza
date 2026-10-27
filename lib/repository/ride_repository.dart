import 'package:drift/drift.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';

/// This class represents the repository that manages the rides.
class RideRepository {
  const new(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// Add [Ride]s for the given [dates].
  Future<void> addRides(Iterable<DateTime> dates) {
    return _database.batch(
      (batch) => batch.insertAll(_database.rides, [for (final date in dates) RidesCompanion(date: Value(date))]),
    );
  }

  /// Delete the given [ride].
  Future<void> deleteRide(Ride ride) => _database.delete(_database.rides).delete(ride);

  /// Delete the entire ride calendar.
  Future<void> deleteRideCalendar() => _database.delete(_database.rides).go();

  /// Get the attendees of the ride with the given [date].
  Future<List<Rider>> getRideAttendees(DateTime date) async {
    final rideQuery = _database.select(_database.rides)
      ..where((t) => t.date.equals(date))
      ..limit(1);
    final ride = await rideQuery.getSingleOrNull();

    if (ride == null) {
      return [];
    }

    final attendeeQuery =
        _database.select(_database.rideAttendees).join([
            innerJoin(_database.riders, _database.riders.id.equalsExp(_database.rideAttendees.riderId)),
          ])
          ..where(_database.rideAttendees.rideId.equals(ride.id))
          ..orderBy([
            .asc(_database.riders.firstName),
            .asc(_database.riders.lastName),
            .asc(_database.riders.alias, nulls: .last),
          ]);

    return attendeeQuery.map((row) => row.readTable(_database.riders)).get();
  }

  /// Get the ride with the given [id], or `null` if it does not exist.
  Future<Ride?> getRideById(int id) async {
    final query = _database.select(_database.rides)..where((t) => t.id.equals(id));

    return await query.getSingleOrNull();
  }

  /// Get the dates of the rides in the calendar.
  ///
  /// The returned list is not sorted on [Ride.date].
  Future<List<DateTime>> getRideDates() async {
    final query = _database.selectOnly(_database.rides)..addColumns([_database.rides.date]);
    final rows = await query.map((row) => row.read(_database.rides.date)).get();

    return [for (final row in rows) ?row];
  }

  /// Get the list of rides, sorted by date in descending order.
  Future<List<Ride>> getRides() {
    return (_database.select(_database.rides)..orderBy([(ride) => .desc(ride.date)])).get();
  }

  /// Get the amount of rides in the calendar.
  Future<int> getRidesCount() async {
    return await _database.rides.count().getSingleOrNull() ?? 0;
  }

  /// Get the attendees of the ride with the given [date], as scan results.
  Future<List<ScannedRideAttendee>> getScanResults(DateTime date) async {
    final rideQuery = _database.select(_database.rides)
      ..where((t) => t.date.equals(date))
      ..limit(1);
    final ride = await rideQuery.getSingleOrNull();

    if (ride == null) {
      return [];
    }

    final attendees = await (_database.select(_database.rideAttendees)..where((t) => t.rideId.equals(ride.id))).get();

    return [for (final attendee in attendees) ScannedRideAttendee(id: attendee.id, isScanned: attendee.isScanned)];
  }

  /// Update the given [ride] and its [attendees].
  Future<void> updateRide(Ride ride, List<RideAttendeesCompanion> attendees) {
    // TODO: use diffing instead of bulk delete and insert
    return _database.transaction(() async {
      await (_database.delete(_database.rideAttendees)..where((t) => t.rideId.equals(ride.id))).go();

      await _database.batch((batch) {
        batch.insertAll(_database.rideAttendees, attendees);
      });

      await _database.update(_database.rides).replace(ride);
    });
  }

  /// Get a [Stream] of changes to the amount of rides.
  Stream<int> watchRidesCount() => _database.rides.count().watchSingleOrNull().map((count) => count ?? 0);
}
