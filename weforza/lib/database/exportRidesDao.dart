
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
      this._rideAttendeeStore): assert(_database != null
      && _memberStore != null && _rideStore != null
      && _rideAttendeeStore != null
  );

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

  @override
  Future<Iterable<ExportableRide>> getRides() async {
    HashMap<DateTime, Ride> rides = HashMap();
    HashMap<String, Member> members = HashMap();
    List<RideAttendee> attendees = [];

    //Fetch the rides/members and attendees in parallel.
    //This populates the given collections with data.
    await Future.wait([
      _fetchRides(rides),
      _fetchMembers(members),
      _fetchAttendees(attendees)
    ]);

    return _joinRidesAndAttendees(rides, members, attendees);
  }

  ///Fetch the rides and store them in [collection].
  ///A HashMap is used for fast lookup later.
  ///We return a Future<void> for use with Future.wait().
  Future<void> _fetchRides(HashMap<DateTime, Ride> collection) async {
    final records = await _rideStore.find(_database);

    records.map((record){
      final Ride ride = Ride.of(DateTime.parse(record.key), record.value);
      collection[ride.date] = ride;
    });
  }

  ///Fetch the members and store them in [collection].
  ///A HashMap is used for fast lookup later.
  ///We return a Future<void> for use with Future.wait().
  Future<void> _fetchMembers(HashMap<String, Member> collection) async {
    final records = await _memberStore.find(_database);

    records.map((record){
      final Member member = Member.of(record.key, record.value);
      collection[member.uuid] = member;
    });
  }

  ///Fetch the ride attendees and store them in [collection].
  ///An Iterable is used, since all we do with the attendees is do a data match per item, by using the ride/member HashMaps.
  ///We return a Future<void> for use with Future.wait().
  Future<void> _fetchAttendees(List<RideAttendee> collection) async {
    final records = await _rideAttendeeStore.find(_database);

    records.map((record) => collection.add(RideAttendee.of(record.value)));
  }

  Iterable<ExportableRide> _joinRidesAndAttendees(HashMap<DateTime, Ride> rides, HashMap<String, Member> members, Iterable<RideAttendee> attendees) {
    final HashMap<DateTime, ExportableRide> exports = HashMap();

    attendees.forEach((attendee) {
      final Ride ride = rides[attendee.rideDate];
      final Member member = members[attendee.attendeeId];

      if(exports.containsKey(ride.date)){
        //The ride itself is already set. Append the attendees.
        exports[ride].attendees.add(ExportableRideAttendee(
          //TODO once we add aliases add them here too
          firstName: member.firstname,
          lastName: member.lastname,
        ));
      }else{
        //The ride wasn't stored yet. Add the ride + the current attendee.
        exports[ride.date] = ExportableRide(
          ride: ride,
          attendees: [ExportableRideAttendee(
            //TODO once we add aliases add them here too
            firstName: member.firstname,
            lastName: member.lastname,
          )],
        );
      }
    });

    return exports.values;
  }
}