import 'package:sembast/sembast.dart';
import 'package:weforza/database/database_tables.dart';

import 'package:weforza/extensions/date_extension.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/ride_attendee.dart';

/// This class defines an interface to work with members.
abstract class MemberDao {
  /// Add a [member].
  Future<void> addMember(Member member);

  /// Delete the member with the given [uuid].
  Future<void> deleteMember(String uuid);

  /// Get the amount of rides that a member with the given [uuid] has attended.
  Future<int> getAttendingCount(String uuid);

  /// Get the list of members that satisfy the given [filter].
  Future<List<Member>> getMembers(MemberFilterOption filter);

  /// Check whether a member exists.
  ///
  /// If [uuid] is null, this method returns whether a member exists
  /// with the given [firstname], [lastname] and [alias].
  ///
  /// If [uuid] is not null, this method returns whether a member exists
  /// with the given [firstname], [lastname], [alias] and a uuid
  /// that is *different* from the given uuid.
  Future<bool> memberExists(
    String firstname,
    String lastname,
    String alias, [
    String? uuid,
  ]);

  /// Toggle the active state of the member with the given [uuid].
  Future<void> setMemberActive(String uuid, bool value);

  /// Update the given [member].
  Future<void> updateMember(Member member);
}

/// This class represents the default implementation of [MemberDao].
class MemberDaoImpl implements MemberDao {
  /// The default constructor.
  MemberDaoImpl(this._database, DatabaseTables tables)
      : _deviceStore = tables.device,
        _memberStore = tables.member,
        _rideAttendeeStore = tables.rideAttendee;

  /// A reference to the database.
  final Database _database;

  /// A reference to the [Device] store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  /// A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;

  /// A reference to the [RideAttendee] store.
  final StoreRef<String, Map<String, dynamic>> _rideAttendeeStore;

  @override
  Future<void> addMember(Member member) async {
    final recordRef = _memberStore.record(member.uuid);

    if (await recordRef.exists(_database)) {
      return Future.error(
        ArgumentError('The uuid ${member.uuid} is already in use'),
      );
    }

    await recordRef.add(_database, member.toMap());
  }

  @override
  Future<void> deleteMember(String uuid) {
    return _database.transaction((txn) async {
      await _memberStore.record(uuid).delete(txn);
      await _rideAttendeeStore.delete(
        txn,
        finder: Finder(filter: Filter.equals('attendee', uuid)),
      );
      await _deviceStore.delete(
        txn,
        finder: Finder(filter: Filter.equals('owner', uuid)),
      );
    });
  }

  @override
  Future<int> getAttendingCount(String uuid) {
    return _rideAttendeeStore.count(
      _database,
      filter: Filter.equals('attendee', uuid),
    );
  }

  @override
  Future<List<Member>> getMembers(MemberFilterOption filter) async {
    final finder = Finder(
      sortOrders: [
        SortOrder('firstname'),
        SortOrder('lastname'),
        SortOrder('alias'),
      ],
    );

    switch (filter) {
      case MemberFilterOption.active:
        finder.filter = Filter.equals('active', true);
        break;
      case MemberFilterOption.inactive:
        finder.filter = Filter.equals('active', false);
        break;
      default:
        break;
    }

    final records = await _memberStore.find(_database, finder: finder);

    return records.map((r) => Member.of(r.key, r.value)).toList();
  }

  @override
  Future<bool> memberExists(
    String firstname,
    String lastname,
    String alias, [
    String? uuid,
  ]) async {
    final filters = [
      Filter.equals('firstname', firstname),
      Filter.equals('lastname', lastname),
      Filter.equals('alias', alias),
    ];

    if (uuid != null && uuid.isNotEmpty) {
      filters.add(Filter.notEquals(Field.key, uuid));
    }

    final finder = Finder(filter: Filter.and(filters));

    return await _memberStore.findFirst(_database, finder: finder) != null;
  }

  @override
  Future<void> setMemberActive(String uuid, bool value) async {
    final record = _memberStore.record(uuid);

    if (await record.exists(_database)) {
      await record.update(
        _database,
        {
          'active': value,
          'lastUpdated': DateTime.now().toStringWithoutMilliseconds()
        },
      );
    }
  }

  @override
  Future<void> updateMember(Member member) {
    return _memberStore.record(member.uuid).update(_database, member.toMap());
  }
}
