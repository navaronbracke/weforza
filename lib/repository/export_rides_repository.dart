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
    final rides = _database.rides;
    final rideAttendees = _database.rideAttendees;
    final riders = _database.riders;

    final query = rides.selectOnly().join([
      leftOuterJoin(rideAttendees, rideAttendees.rideId.equalsExp(rides.id)),
      leftOuterJoin(riders, riders.id.equalsExp(rideAttendees.riderId)),
    ])..addColumns([rides.id, rides.date, riders.alias, riders.firstName, riders.lastName]);

    if (ride != null) {
      query.where(rides.date.equals(ride));
    } else {
      // Multiple rides should be ordered on date.
      query.orderBy([.desc(rides.date)]);
    }

    // The map preserves the insertion order, which is the order of the rides.
    final ridesById = <int, (DateTime, List<ExportableRideAttendee>)>{};

    for (final row in await query.get()) {
      final int? rideId = row.read(rides.id);
      final DateTime? date = row.read(rides.date);

      if (rideId == null || date == null) {
        continue;
      }

      // Ensure that each ride has at least an empty attendees list.
      final List<ExportableRideAttendee> attendees = ridesById
          .putIfAbsent(rideId, () => (date, <ExportableRideAttendee>[]))
          .$2;

      // Rides without attendees have null rider columns, due to the left join.
      final String? firstName = row.read(riders.firstName);
      final String? lastName = row.read(riders.lastName);

      if (firstName == null || firstName.isEmpty || lastName == null || lastName.isEmpty) {
        continue;
      }

      attendees.add(
        ExportableRideAttendee(alias: row.read(riders.alias) ?? '', firstName: firstName, lastName: lastName),
      );
    }

    return [
      for (final (date, attendees) in ridesById.values)
        ExportableRideWithAttendees(
          ride: ExportableRide(date: date),
          attendees: attendees..sort(ExportableRideAttendee.sortByName),
        ),
    ];
  }
}
