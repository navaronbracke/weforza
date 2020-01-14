
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

  ///Update the [Attendee]s for the [Ride] with the given date.
  ///The attendees of the [Ride] with the given date will be replaced by [attendees].
  Future<void> updateAttendeesForRideWithDate(DateTime date, List<RideAttendee> attendees);

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
    //Get the rides
    final rideRecords =  await _rideStore.find(_database);
    final rides = rideRecords.map((record) => Ride(DateTime.parse(record.key))).toList();
    //Get the attendees per ride
    final attendeesPerRide = await _getAttendeeCountPerRide();
    //Per ride update its attendee count.
    rides.forEach((ride){
      if(attendeesPerRide.containsKey(ride.date)){
        ride.numberOfAttendees = attendeesPerRide[ride.date];
      }
    });
    rides.sort((Ride r1, Ride r2)=> r1.date.compareTo(r2.date));
    return rides.reversed.toList();
  }

  @override
  Future<void> updateAttendeesForRideWithDate(DateTime date, List<RideAttendee> attendees) async {
    final finder = Finder(filter: Filter.equals("date", date.toIso8601String()));

    await _database.transaction((txn) async {
      await _rideAttendeeStore.delete(txn,finder: finder);
      await _rideAttendeeStore.records(attendees.map((a)=> a.uuid).toList())
          .put(txn, attendees.map((a)=> a.toMap()).toList());
    });
  }

  @override
  Future<List<DateTime>> getRideDates() async {
    final rides = await _rideStore.findKeys(_database);
    return rides.map((ride) => DateTime.parse(ride)).toList();
  }

  Future<Map<DateTime, int>> _getAttendeeCountPerRide() async {
    //Get all ride attendee records.
    final List<RecordSnapshot<String, dynamic>> records = await _rideAttendeeStore.find(_database);
    final Map<DateTime,int> map = {};
    //Count the occurrences of the keys.
    records.forEach((record){
      final key = DateTime.parse(record.value["date"]);
      if(map.containsKey(key)){
        map[key]++;
      }else{
        map[key] = 1;
      }
    });
    return map;
  }
}