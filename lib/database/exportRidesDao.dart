
import 'dart:collection';

import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/exportableRide.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';

abstract class IExportRidesDao {
  //Get the exportable rides with their attendees.
  Future<Iterable<ExportableRide>> getRides();
}

class ExportRidesDao implements IExportRidesDao {
  ExportRidesDao(
      this._database,
      this._memberStore,
      this._rideStore,
      this._rideAttendeeStore);

  ExportRidesDao.withProvider(ApplicationDatabase provider): this(
    provider.getDatabase(),
    provider.memberStore,
    provider.rideStore,
    provider.rideAttendeeStore
  );

  ///A reference to the database, which is needed by the Store.
  final Database _database;

  ///A reference to the [Ride] store.
  final StoreRef<String, Map<String, dynamic>> _rideStore;
  ///A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;
  ///A reference to the [RideAttendee] store.
  final StoreRef<String, Map<String, dynamic>> _rideAttendeeStore;

  final HashMap<DateTime, Ride> rides = HashMap();
  final HashMap<String, Member> members = HashMap();
  final HashMap<DateTime, Set<RideAttendee>> attendees = HashMap();

  @override
  Future<Iterable<ExportableRide>> getRides() async {
    //Fetch the rides/members and attendees in parallel.
    //This populates the given collections with data.
    await Future.wait([
      _fetchRides(rides),
      _fetchMembers(members),
      _fetchAttendees(attendees)
    ]);

    return _joinRidesAndAttendees(rides, members, attendees);
  }

  Future<void> _fetchRides(HashMap<DateTime, Ride> rides) async {
    final records = await _rideStore.find(_database);

    records.forEach((record) {
      final Ride ride = Ride.of(DateTime.parse(record.key), record.value);
      rides[ride.date] = ride;
    });
  }

  Future<void> _fetchMembers(HashMap<String, Member> members) async {
    final records = await _memberStore.find(_database);

    records.forEach((record){
      final Member member = Member.of(record.key, record.value);
      members[member.uuid] = member;
    });
  }

  Future<void> _fetchAttendees(HashMap<DateTime, Set<RideAttendee>> attendees) async {
    final records = await _rideAttendeeStore.find(_database);
    
    records.forEach((record){
      final RideAttendee attendee = RideAttendee.of(record.value);
      if(attendees.containsKey(attendee.rideDate)){
        attendees[attendee.rideDate]!.add(attendee);
      }else{
        attendees[attendee.rideDate] = Set.from([attendee]);
      }
    });
  }

  Iterable<ExportableRide> _joinRidesAndAttendees(HashMap<DateTime, Ride> rides, HashMap<String, Member> members, HashMap<DateTime, Set<RideAttendee>> attendees) {
    final List<ExportableRide> exports = [];

    rides.forEach((DateTime rideDate, Ride ride) {
      final Iterable<ExportableRideAttendee> membersAttendingRide = attendees.containsKey(rideDate) ? attendees[rideDate]!.map((RideAttendee attendee){
        final Member member = members[attendee.uuid]!;
        return ExportableRideAttendee(
          firstName: member.firstname,
          lastName: member.lastname,
          alias: member.alias,
        );
      }) : [];

      exports.add(ExportableRide(
          ride: ride,
          attendees: membersAttendingRide
      ));
    });

    return exports;
  }
}