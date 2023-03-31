import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/RideAttendee.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';

///This interface defines a contract to manipulate [Member]s in persistent storage.
abstract class IMemberDao {
  ///Add a [Member] to the database.
  Future<void> addMember(Member member);

  ///Delete a [Member] from the database.
  Future<void> deleteMember(String uuid);

  ///Update a [Member].
  Future<void> updateMember(Member member);

  ///Get the [Member]s, using the given [MemberFilterOption].
  Future<List<Member>> getMembers(MemberFilterOption filterOption);

  ///Check if a [Member] with the given values exists.
  ///If [uuid] is null or empty, it checks whether there is a member with the given values.
  ///
  ///If [uuid] isn't null or empty it checks if there is a member with the values and a uuid that is different from [uuid].
  ///A member with the same values and uuid means it's the owner of said values.
  ///This would merely overwrite the old one with a copy of itself and is thus harmless.
  Future<bool> memberExists(String firstname, String lastname, String alias, [String? uuid]);

  ///Get the number of rides a [Member] with the given id attended.
  Future<int> getAttendingCountForAttendee(String uuid);

  /// Set the active state for a given member to the new value.
  Future<void> setMemberActive(String uuid, bool value);
}

///This class is an implementation of [IMemberDao].
class MemberDao implements IMemberDao {
  MemberDao(
      this._database,
      this._memberStore,
      this._rideAttendeeStore,
      this._deviceStore);

  MemberDao.withProvider(ApplicationDatabase provider): this(
    provider.getDatabase(),
    provider.memberStore,
    provider.rideAttendeeStore,
    provider.deviceStore
  );

  ///A reference to the application database.
  final Database _database;
  ///A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;
  ///A reference to the [RideAttendee] store.
  final StoreRef<String, Map<String, dynamic>> _rideAttendeeStore;
  ///A reference to the [Device] store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  @override
  Future<void> addMember(Member member) async  {
    ///The uuid is already used
    if(await _memberStore.findFirst(_database, finder: Finder(filter: Filter.byKey(member.uuid))) != null){
      throw Exception("The member's uuid: ${member.uuid} is already in use");
    }
    await _memberStore.record(member.uuid).add(_database, member.toMap());
  }

  @override
  Future<void> deleteMember(String uuid) async {
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
  Future<List<Member>> getMembers(MemberFilterOption filterOption) async {
    final Finder finder = Finder(
        sortOrders: [SortOrder("firstname"),SortOrder("lastname"),SortOrder("alias")]
    );

    switch(filterOption){
      case MemberFilterOption.ACTIVE: finder.filter = Filter.equals("active", true); break;
      case MemberFilterOption.INACTIVE: finder.filter = Filter.equals("active", false); break;
      default: break;
    }

    final Iterable<Member> members = await _memberStore.find(_database,finder: finder).then((records){
      return records.map((record)=> Member.of(record.key, record.value));
    });

    return members.toList();
  }

  @override
  Future<void> updateMember(Member member) async {
    final finder = Finder(
      filter: Filter.byKey(member.uuid),
    );

    await _memberStore.update(_database,member.toMap(),finder: finder);
  }

  @override
  Future<bool> memberExists(String firstname, String lastname, String alias, [String? uuid]) async {
    final List<Filter> filters = [
      Filter.equals("firstname", firstname),
      Filter.equals("lastname", lastname),
      Filter.equals("alias", alias),
    ];
    if(uuid != null && uuid.isNotEmpty){
      filters.add(Filter.notEquals(Field.key, uuid));
    }

    final finder = Finder(filter: Filter.and(filters));

    return await _memberStore.findFirst(_database,finder: finder) != null;
  }

  @override
  Future<int> getAttendingCountForAttendee(String uuid) {
    return _rideAttendeeStore.count(_database, filter: Filter.equals("attendee", uuid));
  }

  @override
  Future<void> setMemberActive(String uuid, bool value) async {
    final record = _memberStore.record(uuid);

    if(await record.exists(_database)){
      await record.update(_database, { "active": value});
    }
  }
}