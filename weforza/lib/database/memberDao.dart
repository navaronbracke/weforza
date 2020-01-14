import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/RideAttendee.dart';
import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/member.dart';

///This interface defines a contract to manipulate [Member]s in persistent storage.
abstract class IMemberDao {
  ///Add a [Member] to the database.
  Future<void> addMember(Member member);

  ///Delete a [Member] from the database.
  Future<void> deleteMember(String uuid);

  ///Update a [Member].
  Future<void> updateMember(Member member);

  ///Get all [Member]s.
  Future<List<Member>> getMembers();

  ///Check if a [Member] with the given values exists.
  Future<bool> memberExists(String firstname, String lastname, String phone);

  ///Get the number of rides a [Member] with the given id attended.
  Future<int> getAttendingCountForAttendee(String uuid);

  ///Get the [Attendee]s of a given ride.
  ///This method is intended for use with a [Ride] detail page.
  Future<List<Attendee>> getRideAttendees(DateTime date);

  //TODO add /edit /delete device for member
}

///This class is an implementation of [IMemberDao].
class MemberDao implements IMemberDao {
  MemberDao(this._database): assert(_database != null);

  ///A reference to the database, which is needed by the Store.
  final Database _database;
  ///A reference to the [Member] store.
  final _memberStore = DatabaseProvider.memberStore;
  ///A reference to the [RideAttendee] store.
  final _rideAttendeeStore = DatabaseProvider.rideAttendeeStore;

  @override
  Future<void> addMember(Member member) async  {
    assert(member != null);
    await _memberStore.record(member.uuid).add(_database, member.toMap());
  }

  @override
  Future<void> deleteMember(String uuid) async {
    assert(uuid != null && uuid.isNotEmpty);
    //delete the ride attendee records and the member
    final memberFinder = Finder(filter: Filter.byKey(uuid));
    final memberRidesFinder = Finder(filter: Filter.equals("attendee", uuid));
    
    await _database.transaction((txn) async {
      await _memberStore.delete(txn,finder: memberFinder);
      await _rideAttendeeStore.delete(txn,finder: memberRidesFinder);
    });
  }

  @override
  Future<List<Member>> getMembers() async {
    final finder = Finder(
        sortOrders: [SortOrder("firstname"),SortOrder("lastname"),SortOrder("phone")]
    );

    final records = await _memberStore.find(_database,finder: finder);

    return records.map((record)=> Member.of(record.key, record.value)).toList();
  }

  @override
  Future<void> updateMember(Member member) async {
    assert(member != null);
    final finder = Finder(
      filter: Filter.byKey(member.uuid),
    );

    await _memberStore.update(_database,member.toMap(),finder: finder);
  }

  @override
  Future<bool> memberExists(String firstname, String lastname, String phone) async {
    assert(firstname != null && lastname != null && phone != null);

    final finder = Finder(filter: Filter.and([
      Filter.equals("firstname", firstname),
      Filter.equals("lastname", lastname),
      Filter.equals("phone", phone),
    ]));

    return await _memberStore.findFirst(_database,finder: finder) != null;
  }

  @override
  Future<int> getAttendingCountForAttendee(String uuid) async {
    final finder = Finder(filter: Filter.equals("attendee", uuid));

    final records = await _rideAttendeeStore.find(_database,finder: finder);

    return records.length;
  }

  @override
  Future<List<Attendee>> getRideAttendees(DateTime date) async {
    final rideAttendeeFinder = Finder(filter: Filter.equals("date", date.toIso8601String()));
    //fetch the attendees of the ride and map to their uuid's
    final rideAttendeeRecords = await _rideAttendeeStore.find(_database,finder: rideAttendeeFinder);
    final attendeeIds = rideAttendeeRecords.map((record) => record.value["attendee"]);
    //fetch the members that belong to the attendee uuid's
    final memberFinder = Finder(filter: Filter.custom((record) => attendeeIds.contains(record.key))
        ,sortOrders: [SortOrder("firstname"),SortOrder("lastname")]);
    final memberRecords = await _memberStore.find(_database,finder: memberFinder);
    //map the record snapshots to Attendee objects
    return memberRecords.map((record) => Attendee.of(record.key, record.value)).toList();
  }
}