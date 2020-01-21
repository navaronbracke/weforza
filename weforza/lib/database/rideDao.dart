
import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/attendee.dart';
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

  ///Update the [Attendee]s for the [Ride].
  ///The attendees of the [Ride] will be replaced by [attendees].
  Future<void> updateAttendeesForRideWithDate(Ride ride, List<RideAttendee> attendees);

  ///Get the dates of the existing rides.
  Future<List<DateTime>> getRideDates();
}

class RideDao implements IRideDao {
  RideDao(this._database): assert(_database != null);

  ///A reference to the database.
  final Database _database;
  ///A reference to the [RideAttendee] store.
  final _rideAttendeeStore = DatabaseProvider.rideAttendeeStore;
  ///A reference to the [Ride] store.
  final _rideStore = DatabaseProvider.rideStore;


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
  Future<void> updateAttendeesForRideWithDate(Ride ride, List<RideAttendee> attendees) async {
    assert(ride != null && ride.date != null && attendees != null);
    final date = ride.date.toIso8601String();
    final finder = Finder(filter: Filter.equals("date", date));

    await _database.transaction((txn) async {
      //Delete old ones, replace by new ones.
      await _rideAttendeeStore.delete(txn,finder: finder);
      await _rideAttendeeStore.records(attendees.map((a)=> "$date${a.attendeeId}").toList())
          .put(txn, attendees.map((a)=> a.toMap()).toList());
      //create the updated ride object from the existing ride, but with the new count.
      final updatedRide = ride.toMap();
      updatedRide["attendees"] = attendees.length;
      //update the ride.
      await _rideStore.update(txn, updatedRide,finder: Finder(filter: Filter.byKey(date)));
    });
  }

  @override
  Future<List<DateTime>> getRideDates() async {
    final rides = await _rideStore.findKeys(_database);
    return rides.map((ride) => DateTime.parse(ride)).toList();
  }
}