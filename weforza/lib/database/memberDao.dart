import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/RideAttendee.dart';
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
  ///If [uuid] is null or empty, it checks whether there is a member with the given values.
  ///
  ///If [uuid] isn't null or empty it checks if there is a member with the values and a uuid that is different from [uuid].
  ///A member with the same values and uuid means it's the owner of said values.
  ///This would merely overwrite the old one with a copy of itself and is thus harmless.
  Future<bool> memberExists(String firstname, String lastname, String phone,[String uuid]);

  ///Get the number of rides a [Member] with the given id attended.
  Future<int> getAttendingCountForAttendee(String uuid);

  ///Get the [Member]s of a given ride.
  ///This method is intended for use with a [Ride] detail page.
  Future<List<Member>> getRideAttendees(DateTime date);

  ///Get the member with the given UUID.
  ///Returns null if it doesn't exist.
  Future<Member> getMemberByUuid(String uuid);
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
  ///A reference to the [Device] store.
  final _deviceStore = DatabaseProvider.deviceStore;

  @override
  Future<void> addMember(Member member) async  {
    assert(member != null && member.uuid != null);
    ///The uuid is already used
    if(await _memberStore.findFirst(_database,finder: Finder(filter: Filter.byKey(member.uuid)))!= null){
      throw Exception("The member's uuid: ${member.uuid} is already in use");
    }
    await _memberStore.record(member.uuid).add(_database, member.toMap());
  }

  @override
  Future<void> deleteMember(String uuid) async {
    assert(uuid != null);
    //delete the ride attendee records, the member's devices and the member
    final memberFinder = Finder(filter: Filter.byKey(uuid));
    final memberRidesFinder = Finder(filter: Filter.equals("attendee", uuid));
    final memberDeviceFinder = Finder(filter: Filter.equals("owner", uuid));
    
    await _database.transaction((txn) async {
      await _memberStore.delete(txn,finder: memberFinder);
      await _rideAttendeeStore.delete(txn,finder: memberRidesFinder);
      await _deviceStore.delete(txn,finder: memberDeviceFinder);
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
  Future<bool> memberExists(String firstname, String lastname, String phone, [String uuid]) async {
    final List<Filter> filters = [
      Filter.equals("firstname", firstname),
      Filter.equals("lastname", lastname),
      Filter.equals("phone", phone),
    ];
    if(uuid != null && uuid.isNotEmpty){
      filters.add(Filter.notEquals(Field.key, uuid));
    }

    final finder = Finder(filter: Filter.and(filters));

    return await _memberStore.findFirst(_database,finder: finder) != null;
  }

  @override
  Future<int> getAttendingCountForAttendee(String uuid) async {
    final finder = Finder(filter: Filter.equals("attendee", uuid));

    final records = await _rideAttendeeStore.find(_database,finder: finder);

    return records.length;
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

  @override
  Future<Member> getMemberByUuid(String uuid) async {
    final record = await _memberStore.record(uuid).getSnapshot(_database);

    if(record == null){
      return null;
    }else{
      //need record snapshot
      return Member.of(uuid, record.value);
    }
  }
}