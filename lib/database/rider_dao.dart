import 'package:sembast/sembast.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/extensions/date_extension.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class defines an interface to work with riders.
abstract class RiderDao {
  /// Add a [rider].
  Future<void> addRider(Rider rider);

  /// Delete the rider with the given [uuid].
  Future<void> deleteRider(String uuid);

  /// Get the amount of rides that a rider with the given [uuid] has attended.
  Future<int> getAttendingCount(String uuid);

  /// Get the list of riders that satisfy the given [filter].
  Future<List<Rider>> getRiders(RiderFilterOption filter);

  /// Toggle the active state of the rider with the given [uuid].
  Future<void> setRiderActive(String uuid, {required bool value});

  /// Update the given [rider].
  Future<void> updateRider(Rider rider);
}

/// This class represents the default implementation of [RiderDao].
class RiderDaoImpl implements RiderDao {
  /// The default constructor.
  RiderDaoImpl(this._database);

  /// A reference to the database.
  final Database _database;

  /// A reference to the [Device] store.
  final _deviceStore = DatabaseTables.device;

  /// A reference to the [Rider] store.
  final _riderStore = DatabaseTables.rider;

  /// A reference to the [RideAttendee] store.
  final _rideAttendeeStore = DatabaseTables.rideAttendee;

  /// Check whether a rider exists.
  ///
  /// If [uuid] is null, this method returns whether a rider exists
  /// with the given [firstName], [lastName] and [alias].
  ///
  /// If [uuid] is not null, this method returns whether a rider exists
  /// with the given [firstName], [lastName], [alias] and a uuid
  /// that is *different* from the given uuid.
  Future<bool> _riderExists(
    String firstName,
    String lastName,
    String alias, [
    String? uuid,
  ]) async {
    final filters = [
      Filter.equals('firstname', firstName),
      Filter.equals('lastname', lastName),
      Filter.equals('alias', alias),
    ];

    if (uuid != null && uuid.isNotEmpty) {
      filters.add(Filter.notEquals(Field.key, uuid));
    }

    final finder = Finder(filter: Filter.and(filters));

    return await _riderStore.findFirst(_database, finder: finder) != null;
  }

  @override
  Future<void> addRider(Rider rider) async {
    final recordRef = _riderStore.record(rider.uuid);

    if (await recordRef.exists(_database)) {
      throw ArgumentError('The uuid ${rider.uuid} is already in use');
    }

    final alias = rider.alias;
    final firstName = rider.firstName;
    final lastName = rider.lastName;

    if (await _riderExists(firstName, lastName, alias)) {
      throw RiderExistsException();
    }

    await recordRef.add(_database, rider.toMap());
  }

  @override
  Future<void> deleteRider(String uuid) {
    return _database.transaction((txn) async {
      await _riderStore.record(uuid).delete(txn);
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
  Future<List<Rider>> getRiders(RiderFilterOption filter) async {
    final finder = Finder(
      sortOrders: [
        SortOrder('firstname'),
        SortOrder('lastname'),
        SortOrder('alias'),
      ],
    );

    switch (filter) {
      case RiderFilterOption.active:
        finder.filter = Filter.equals('active', true);
        break;
      case RiderFilterOption.inactive:
        finder.filter = Filter.equals('active', false);
        break;
      default:
        break;
    }

    final records = await _riderStore.find(_database, finder: finder);

    return records.map((r) => Rider.of(r.key, r.value)).toList();
  }

  @override
  Future<void> setRiderActive(String uuid, {required bool value}) async {
    final record = _riderStore.record(uuid);

    if (await record.exists(_database)) {
      await record.update(
        _database,
        {'active': value, 'lastUpdated': DateTime.now().toStringWithoutMilliseconds()},
      );
    }
  }

  @override
  Future<void> updateRider(Rider rider) async {
    final alias = rider.alias;
    final firstName = rider.firstName;
    final lastName = rider.lastName;
    final uuid = rider.uuid;

    if (await _riderExists(firstName, lastName, alias, uuid)) {
      throw RiderExistsException();
    }

    await _riderStore.record(rider.uuid).update(_database, rider.toMap());
  }
}
