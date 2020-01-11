
import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';

///This interface provides a contract for manipulating [Ride]s in persistent storage.
abstract class IRideDao {

  ///Add rides for the given dates.
  Future<void> addRides(List<Ride> rides);

  ///Delete a ride with the given ride date.
  Future<void> deleteRide(DateTime date);

  ///Delete all rides.
  Future<void> deleteAllRides();

  ///Get all rides.
  Future<List<Ride>> getRides();

  ///Update the [Attendee]s for the [Ride] with the given date.
  Future<void> updateAttendees(DateTime date, List<RideAttendee> attendees);

  ///Get the number of attendees per ride date.
  Future<Map<DateTime,int>> getAttendeeCountPerRide();
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
    await _rideStore.records(rides.map((r) => r.date.toIso8601String()))
        .put(_database, rides.map((r)=> r.toMap()));
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
    final records =  await _rideStore.find(_database);
    final rides = records.map((record) => Ride(DateTime.parse(record.key)));
    final attendeesPerRide = await getAttendeeCountPerRide();
    rides.map((ride){
      if(attendeesPerRide.containsKey(ride.date)){
        ride.numberOfAttendees = attendeesPerRide[ride.date];
      }
    });
    return rides;
  }

  @override
  Future<void> updateAttendees(DateTime date, List<RideAttendee> attendees) async {
    final finder = Finder(filter: Filter.equals("date", date.toIso8601String()));

    await _database.transaction((txn) async {
      await _rideAttendeeStore.delete(txn,finder: finder);
      await _rideAttendeeStore.records(attendees.map((a)=> a.uuid))
          .put(txn, attendees.map((a)=> a.toMap()));
    });
  }

  @override
  Future<Map<DateTime, int>> getAttendeeCountPerRide() async {
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