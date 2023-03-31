import 'package:sembast/sembast.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/model/export/exportable_ride.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/rider/rider.dart';

abstract class ExportRidesDao {
  /// Get the exportable rides with their attendees.
  ///
  /// If a specific [ride] date is given, only that ride is returned.
  Future<Iterable<ExportableRide>> getRides(DateTime? ride);
}

class ExportRidesDaoImpl implements ExportRidesDao {
  ExportRidesDaoImpl(this._database);

  /// A reference to the database.
  final Database _database;

  /// A reference to the [Rider] store.
  final _memberStore = DatabaseTables.member;

  /// A reference to the [RideAttendee] store.
  final _rideAttendeeStore = DatabaseTables.rideAttendee;

  /// A reference to the [Ride] store.
  final _rideStore = DatabaseTables.ride;

  /// Get the ride attendees per ride.
  ///
  /// If [ride] is not null, only the attendees of this ride are returned.
  ///
  /// Returns a map of ride attendees per ride date.
  Future<Map<DateTime, Set<RideAttendee>>> _getAttendees(DateTime? ride) async {
    Finder? finder;
    final attendees = <DateTime, Set<RideAttendee>>{};

    // Only look for attendees of the given ride.
    if (ride != null) {
      finder = Finder(filter: Filter.matches('date', ride.toIso8601String()));
    }

    final records = await _rideAttendeeStore.find(_database, finder: finder);

    for (final record in records) {
      final attendee = RideAttendee.of(record.value);

      if (attendees.containsKey(attendee.rideDate)) {
        attendees[attendee.rideDate]!.add(attendee);
      } else {
        attendees[attendee.rideDate] = <RideAttendee>{attendee};
      }
    }

    return attendees;
  }

  /// Get all the members, mapped to their [Rider.uuid].
  Future<Map<String, Rider>> _getMembers() async {
    final members = <String, Rider>{};

    final records = await _memberStore.find(_database);

    for (final record in records) {
      final member = Rider.of(record.key, record.value);
      members[member.uuid] = member;
    }

    return members;
  }

  /// Get all the rides, mapped to their date.
  Future<Map<DateTime, Ride>> _getRides(DateTime? rideDate) async {
    final rides = <DateTime, Ride>{};

    // Get the single ride, using the record ref.
    if (rideDate != null) {
      final recordRef = _rideStore.record(rideDate.toIso8601String());
      final value = await recordRef.get(_database);

      if (value != null) {
        rides[rideDate] = Ride.of(rideDate, value);
      }
    } else {
      final records = await _rideStore.find(_database);

      for (final record in records) {
        final ride = Ride.of(DateTime.parse(record.key), record.value);
        rides[ride.date] = ride;
      }
    }

    return rides;
  }

  Iterable<ExportableRide> _joinRidesAndAttendees(
    Map<DateTime, Set<RideAttendee>> attendees,
    Map<String, Rider> members,
    Map<DateTime, Ride> rides,
  ) {
    final exports = <ExportableRide>[];

    for (final ride in rides.entries) {
      final exportableRideAttendees = <ExportableRideAttendee>[];
      final rideAttendees = attendees[ride.key] ?? <RideAttendee>{};

      for (final rideAttendee in rideAttendees) {
        final member = members[rideAttendee.uuid];

        // If a member no longer exists, don't add it.
        if (member != null) {
          exportableRideAttendees.add(
            ExportableRideAttendee(
              alias: member.alias,
              firstName: member.firstName,
              lastName: member.lastName,
            ),
          );
        }
      }

      exports.add(
        ExportableRide(ride: ride.value, attendees: exportableRideAttendees),
      );
    }

    return exports;
  }

  @override
  Future<Iterable<ExportableRide>> getRides(DateTime? ride) async {
    final attendeesFuture = _getAttendees(ride);
    final membersFuture = _getMembers();
    final ridesFuture = _getRides(ride);

    final attendees = await attendeesFuture;
    final members = await membersFuture;
    final rides = await ridesFuture;

    return _joinRidesAndAttendees(attendees, members, rides);
  }
}
