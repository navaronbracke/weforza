import 'package:sembast/sembast.dart';
import 'package:weforza/model/exportable_ride.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';

abstract class IExportRidesDao {
  /// Get the exportable rides with their attendees.
  ///
  /// If a specific [ride] date is given, return only that ride.
  Future<Iterable<ExportableRide>> getRides(DateTime? ride);
}

class ExportRidesDao implements IExportRidesDao {
  ExportRidesDao(
    this._database,
    this._memberStore,
    this._rideStore,
    this._rideAttendeeStore,
  );

  /// A reference to the database, which is needed by the Store.
  final Database _database;

  /// A reference to the [Ride] store.
  final StoreRef<String, Map<String, dynamic>> _rideStore;

  /// A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;

  /// A reference to the [RideAttendee] store.
  final StoreRef<String, Map<String, dynamic>> _rideAttendeeStore;

  Future<void> _fetchAttendees(
    Map<DateTime, Set<RideAttendee>> attendees,
    DateTime? ride,
  ) async {
    Finder? finder;

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
  }

  Future<void> _fetchMembers(Map<String, Member> members) async {
    final records = await _memberStore.find(_database);

    for (final record in records) {
      final member = Member.of(record.key, record.value);
      members[member.uuid] = member;
    }
  }

  Future<void> _fetchRides(
    Map<DateTime, Ride> rides,
    DateTime? rideDate,
  ) async {
    // Get the single ride, using the record ref.
    if (rideDate != null) {
      final recordRef = _rideStore.record(rideDate.toIso8601String());
      final value = await recordRef.get(_database);

      if (value != null) {
        rides[rideDate] = Ride.of(rideDate, value);
      }

      return;
    }

    final records = await _rideStore.find(_database);

    for (final record in records) {
      final ride = Ride.of(DateTime.parse(record.key), record.value);
      rides[ride.date] = ride;
    }
  }

  Iterable<ExportableRide> _joinRidesAndAttendees(
    Map<DateTime, Set<RideAttendee>> attendees,
    Map<String, Member> members,
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
              firstName: member.firstname,
              lastName: member.lastname,
              alias: member.alias,
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
    final attendees = <DateTime, Set<RideAttendee>>{};
    final members = <String, Member>{};
    final rides = <DateTime, Ride>{};

    // Fetch the rides, members and attendees in parallel.
    // This populates the given collections with data.
    await Future.wait([
      _fetchAttendees(attendees, ride),
      _fetchMembers(members),
      _fetchRides(rides, ride),
    ]);

    return _joinRidesAndAttendees(attendees, members, rides);
  }
}
