
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

  ///Add the attendee with the given id to the ride.
  ///Returns whether it was added.
  Future<bool> addAttendeeToRide(Ride ride, RideAttendee attendee);

  ///Remove the attendee with the given id from the ride.
  ///Returns whether it was removed.
  Future<bool> removeAttendeeFromRide(Ride ride, String uuid);
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
      await _rideAttendeeStore.delete(txn,finder: finder);
      await _rideAttendeeStore.records(attendees.map((a)=> "$date${a.uuid}").toList())
          .put(txn, attendees.map((a)=> a.toMap()).toList());
      ride.numberOfAttendees = attendees.length;
    });
  }

  @override
  Future<List<DateTime>> getRideDates() async {
    final rides = await _rideStore.findKeys(_database);
    return rides.map((ride) => DateTime.parse(ride)).toList();
  }

  @override
  Future<bool> addAttendeeToRide(Ride ride, RideAttendee attendee) async {
    assert(ride != null && ride.date != null && attendee != null && attendee.uuid != null && attendee.uuid.isNotEmpty);
    final date = ride.date.toIso8601String();

    if(await _rideAttendeeStore.findFirst(_database,finder: Finder(filter: Filter.byKey("$date${attendee.uuid}"))) == null){
      await _database.transaction((txn)async {
        await _rideAttendeeStore.record("$date${attendee.uuid}").put(txn, attendee.toMap());
        ride.numberOfAttendees++;
      });
      return true;
    }else{
      return false;
    }
  }

  @override
  Future<bool> removeAttendeeFromRide(Ride ride, String uuid) async {
    assert(ride != null && ride.date != null && uuid != null);
    final date = ride.date.toIso8601String();
    if((await _rideAttendeeStore.findFirst(_database,finder: Finder(filter: Filter.byKey("$date$uuid"))) != null)){
      await _database.transaction((txn)async {
        await _rideAttendeeStore.delete(txn,finder: Finder(filter: Filter.byKey("$date$uuid")));
        ride.numberOfAttendees--;
      });
      return true;
    }
    return false;
  }
}