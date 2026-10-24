import 'package:drift/drift.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/export/exportable_ride.dart';
import 'package:weforza/model/export/exportable_ride_attendee.dart';
import 'package:weforza/model/export/exportable_ride_with_attendees.dart';

class ExportRidesRepository {
  const new(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// Get the exportable rides with their attendees.
  ///
  /// If a specific [ride] date is given, only that ride is returned.
  Future<Iterable<ExportableRideWithAttendees>> getRides(DateTime? ride) async {
    final rideDatesById = await _getRides(ride);

    if (rideDatesById.isEmpty) {
      return const [];
    }

    // Get the ids of the attendees, per ride.
    final riderIdsPerRide = await _getRideAttendeeIds(rideDatesById.keys);

    // With the ids from the previous step, read the attendee data.
    final attendeesById = await _getExportableRideAttendees(riderIdsPerRide.values.expand((ids) => ids));

    return [
      for (final MapEntry(key: rideId, value: date) in rideDatesById.entries)
        ExportableRideWithAttendees(
          ride: ExportableRide(date: date),
          attendees: [for (final riderId in riderIdsPerRide[rideId] ?? const <int>{}) ?attendeesById[riderId]],
        ),
    ];
  }

  /// Get the rides with their dates.
  ///
  /// If [ride] is provided, only the rides on that date will be returned.
  Future<Map<int, DateTime>> _getRides(DateTime? ride) async {
    final rides = _database.rides;

    final ridesQuery = rides.selectOnly()..addColumns([rides.id, rides.date]);

    if (ride != null) {
      ridesQuery.where(rides.date.equals(ride));
    }

    return <int, DateTime>{
      for (final row in await ridesQuery.get())
        if ((id: row.read(rides.id), date: row.read(rides.date)) case (id: final id?, date: final date?)) id: date,
    };
  }

  /// Get the attendee ids for the given [rideIds].
  Future<Map<int, Set<int>>> _getRideAttendeeIds(Iterable<int> rideIds) async {
    final rideAttendees = _database.rideAttendees;

    final attendeesQuery = rideAttendees.selectOnly()
      ..addColumns([rideAttendees.rideId, rideAttendees.riderId])
      ..where(rideAttendees.rideId.isIn(rideIds));

    final riderIdsPerRide = <int, Set<int>>{};

    for (final row in await attendeesQuery.get()) {
      if ((rideId: row.read(rideAttendees.rideId), riderId: row.read(rideAttendees.riderId)) case (
        rideId: final rideId?,
        riderId: final riderId?,
      )) {
        riderIdsPerRide.putIfAbsent(rideId, () => {}).add(riderId);
      }
    }

    return riderIdsPerRide;
  }

  Future<Map<int, ExportableRideAttendee>> _getExportableRideAttendees(Iterable<int> riderIds) async {
    if (riderIds.isEmpty) {
      return const {};
    }

    final riders = _database.riders;
    final attendees = <int, ExportableRideAttendee>{};

    final ridersQuery = riders.selectOnly()
      ..addColumns([riders.id, riders.alias, riders.firstName, riders.lastName])
      ..where(riders.id.isIn(riderIds));

    for (final row in await ridersQuery.get()) {
      final riderId = row.read(riders.id);
      final firstName = row.read(riders.firstName) ?? '';
      final lastName = row.read(riders.lastName) ?? '';

      if (riderId == null || firstName.isEmpty || lastName.isEmpty) {
        continue;
      }

      attendees[riderId] = ExportableRideAttendee(
        alias: row.read(riders.alias) ?? '',
        firstName: firstName,
        lastName: lastName,
      );
    }

    return attendees;
  }
}
