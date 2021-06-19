
import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';

///This interface provides a contract for manipulating [Ride]s in persistent storage.
abstract class IRideDao {

  ///Add rides to the database.
  Future<void> addRides(List<Ride> rides);

  ///Delete a ride with the given ride date.
  Future<void> deleteRide(DateTime date);

  ///Delete all rides & attendant records.
  Future<void> deleteRideCalendar();

  ///Get all rides. This method will load all the stored [Ride]s and populate their attendee count.
  Future<List<Ride>> getRides();

  /// Update the scanned attendees counter and attendees list for the given ride.
  Future<void> updateRide(Ride ride, List<RideAttendee> attendees);

  ///Get the dates of the existing rides.
  Future<List<DateTime>> getRideDates();

  ///Get the [Member]s of a given ride.
  Future<List<Member>> getRideAttendees(DateTime date);

  ///Get the amount of attendees for a given ride.
  Future<int> getAmountOfRideAttendees(DateTime rideDate);
}

class RideDao implements IRideDao {
  RideDao(
      this._database,
      this._memberStore,
      this._rideStore,
      this._rideAttendeeStore);

  RideDao.withProvider(ApplicationDatabase provider): this(
    provider.getDatabase(),
    provider.memberStore,
    provider.rideStore,
    provider.rideAttendeeStore
  );

  ///A reference to the database.
  final Database _database;
  ///A reference to the [RideAttendee] store.
  final StoreRef<String, Map<String, dynamic>> _rideAttendeeStore;
  ///A reference to the [Ride] store.
  final StoreRef<String, Map<String, dynamic>> _rideStore;
  ///A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;


  @override
  Future<void> addRides(List<Ride> rides) async {
    await _rideStore.records(rides.map((r) => r.date.toIso8601String()).toList())
        .put(_database, rides.map((r)=> r.toMap()).toList());
  }

  @override
  Future<void> deleteRideCalendar() async {
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
    final rideRecords =  await _rideStore.find(_database,finder: Finder(sortOrders: [SortOrder(Field.key,false)]));
    return rideRecords.map((record) => Ride.of(DateTime.parse(record.key), record.value)).toList();
  }

  @override
  Future<List<DateTime>> getRideDates() async {
    final rides = await _rideStore.findKeys(_database);
    return rides.map((ride) => DateTime.parse(ride)).toList();
  }

  @override
  Future<List<Member>> getRideAttendees(DateTime date) async {
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

  @override
  Future<int> getAmountOfRideAttendees(DateTime rideDate) async {
    //fetch the attendees of the ride
    final attendees = await _rideAttendeeStore.count(_database,
        filter: Filter.equals("date", rideDate.toIso8601String()));

    return attendees;
  }

  @override
  Future<void> updateRide(Ride ride, List<RideAttendee> attendees) async {
    // The key for the ride record is the ride date as an ISO 8601 date string.
    final rideRecordKey = ride.date.toIso8601String();
    // Find the attendees that have the ride record key as date field.
    final rideAttendeeFinder = Finder(filter: Filter.equals("date", rideRecordKey));

    await _database.transaction((txn) async {
      // Update the ride scanned attendees counter in the record.
      await _rideStore.record(rideRecordKey).update(txn, ride.toMap());

      // To update the attendees for the given ride we do the following:
      // - Clear all the old ones
      // - Insert the given attendees (both old and new)
      await _rideAttendeeStore.delete(txn, finder: rideAttendeeFinder);
      // The attendees use the ride record key concatenated with their own UUID
      // as own database record key.
      await _rideAttendeeStore.records(
          attendees.map((a)=> "$rideRecordKey${a.attendeeId}")
      ).put(txn, attendees.map((a)=> a.toMap()).toList());
    });
  }
}