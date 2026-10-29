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
    final Map<int, Set<int>> rideAttendeeIdsPerRide = await _getRideAttendeeIds(rideDatesById.keys);

    // There are no attendees for any of the rides.
    if (rideAttendeeIdsPerRide.isEmpty) {
      return _getExportableRides(rideDatesById, const {}, const {});
    }

    // Get the attendees for said ids.
    final Iterable<int> allAttendeeIds = rideAttendeeIdsPerRide.values.expand((ids) => ids);
    final Map<int, ExportableRideAttendee> riders = await _getExportableRideAttendees(allAttendeeIds);

    return _getExportableRides(rideDatesById, rideAttendeeIdsPerRide, riders);
  }

  /// Get the rides with their dates.
  ///
  /// If [ride] is provided, only the rides on that date will be returned.
  Future<Map<int, DateTime>> _getRides(DateTime? ride) async {
    final rides = _database.rides;

    final ridesQuery = rides.selectOnly()..addColumns([rides.id, rides.date]);

    if (ride != null) {
      ridesQuery.where(rides.date.equals(ride));
    } else {
      // Multiple rides should be ordered on date.
      ridesQuery.orderBy([.desc(rides.date)]);
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

  /// Get the list of [ExportableRideWithAttendees] elements.
  ///
  /// This method essentially walks each ride in [rideDates], collects the corresponding attendees from [rideAttendees],
  /// and then maps those attendees to their exportable representations in [riders].
  ///
  /// The [rideDates] contain the [Ride.date] keyed to the [Ride.id]s.
  /// The [rideAttendees] contain the [Rider.id] keyed to the [Ride.id]s.
  /// The [riders] contain the [ExportableRideAttendee] keyed to the [Rider.id]s.
  List<ExportableRideWithAttendees> _getExportableRides(
    Map<int, DateTime> rideDates,
    Map<int, Set<int>> rideAttendees,
    Map<int, ExportableRideAttendee> riders,
  ) {
    final List<ExportableRideWithAttendees> exportedRides = [];

    for (final MapEntry(key: rideId, value: date) in rideDates.entries) {
      final elements = [for (final riderId in rideAttendees[rideId] ?? const <int>{}) ?riders[riderId]];

      exportedRides.add(
        ExportableRideWithAttendees(
          ride: ExportableRide(date: date),
          attendees: elements..sort(ExportableRideAttendee.sortByName),
        ),
      );
    }

    return exportedRides;
  }
}
