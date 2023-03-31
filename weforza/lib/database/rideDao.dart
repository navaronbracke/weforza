
import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';

///This interface provides a contract for manipulating [Ride]s in persistent storage.
abstract class IRideDao {

  ///Add rides to the database.
  Future<void> addRides(List<Ride> rides);

  ///Delete a ride with the given ride date.
  Future<void> deleteRide(DateTime date);

  ///Delete all rides.
  Future<void> deleteAllRides();

  ///Get all rides. This method will load all the stored [Ride]s and populate their attendee count.
  Future<List<Ride>> getRides();

  ///Update the attendees for the ride with the given date.
  ///The old attendees of the ride will be removed and the new ones will be created.
  Future<void> updateAttendeesForRideWithDate(DateTime rideDate, List<RideAttendee> attendees);

  ///Update a [ride]'s properties, excluding its attendees.
  Future<void> updateRide(Ride ride);

  ///Get the dates of the existing rides.
  Future<List<DateTime>> getRideDates();

  ///Get the [Member]s of a given ride.
  Future<List<Member>> getRideAttendees(DateTime date);
}

class RideDao implements IRideDao {
  RideDao(this._database): assert(_database != null);

  ///A reference to the database.
  final Database _database;
  ///A reference to the [RideAttendee] store.
  final _rideAttendeeStore = DatabaseProvider.rideAttendeeStore;
  ///A reference to the [Ride] store.
  final _rideStore = DatabaseProvider.rideStore;
  ///A reference to the [Member] store.
  final _memberStore = DatabaseProvider.memberStore;


  @override
  Future<void> addRides(List<Ride> rides) async {
    assert(rides != null);
    await _rideStore.records(rides.map((r) => r.date.toIso8601String()).toList())
        .put(_database, rides.map((r)=> r.toMap()).toList());
  }

  @override
  Future<void> deleteAllRides() async {
    await _database.transaction((txn) async {
      await _rideAttendeeStore.delete(txn);
      await _rideStore.delete(txn);
    });
  }

  @override
  Future<void> deleteRide(DateTime date) async {
    assert(date != null);
    final isoDate = date.toIso8601String();
    final rideFinder = Finder(filter: Filter.byKey(isoDate));
    final rideAttendeeFinder = Finder(filter: Filter.equals("date", isoDate));

    await _database.transaction((txn) async {
      await _rideAttendeeStore.delete(txn,finder: rideAttendeeFinder);
      await _rideStore.delete(txn,finder: rideFinder);
    });
  }

  @override
  Future<List<Ride>> getRides() async {
    final rideRecords =  await _rideStore.find(_database,finder: Finder(sortOrders: [SortOrder(Field.key,false)]));
    return rideRecords.map((record) => Ride.of(DateTime.parse(record.key), record.value)).toList();
  }

  @override
  Future<void> updateAttendeesForRideWithDate(DateTime rideDate, List<RideAttendee> attendees) async {
    assert(rideDate != null && attendees != null);
    final date = rideDate.toIso8601String();
    final finder = Finder(filter: Filter.equals("date", date));

    await _database.transaction((txn) async {
      //Delete old ones, replace by new ones.
      await _rideAttendeeStore.delete(txn,finder: finder);
      //The keys are the date + uuid of the person.
      await _rideAttendeeStore.records(attendees.map((a)=> "$date${a.attendeeId}").toList())
          .put(txn, attendees.map((a)=> a.toMap()).toList());
    });
  }

  @override
  Future<List<DateTime>> getRideDates() async {
    final rides = await _rideStore.findKeys(_database);
    return rides.map((ride) => DateTime.parse(ride)).toList();
  }

  @override
  Future<void> updateRide(Ride ride) async {
    return await _rideStore.update(_database, ride.toMap(),finder: Finder(filter: Filter.byKey(ride.date.toIso8601String())));
  }

  @override
  Future<List<Member>> getRideAttendees(DateTime date) async {
    assert(date != null);
    //fetch the attendees of the ride and map to their uuid's
    final rideAttendeeRecords = await _rideAttendeeStore.find(_database,
        finder: Finder(filter: Filter.equals("date", date.toIso8601String())));
    final attendeeIds = rideAttendeeRecords.map((record) => record.value["attendee"]).toList();
    //fetch the members that belong to the attendee uuid's
    final memberRecords = await _memberStore.find(_database,
        finder: Finder(filter: Filter.custom((record) => attendeeIds.contains(record.key)),
            sortOrders: [SortOrder("firstname"),SortOrder("lastname")]));
    //map the record snapshots
    return memberRecords.map((record) => Member.of(record.key, record.value)).toList();
  }
}