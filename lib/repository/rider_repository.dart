import 'dart:async';

import 'package:drift/drift.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class provides an API to work with riders.
class RiderRepository {
  const new(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// Add a [rider].
  Future<void> addRider(Rider rider) async {
    if (await _riderExists(firstName: rider.firstName, lastName: rider.lastName, alias: rider.alias)) {
      throw RiderExistsException();
    }

    await _database.into(_database.riders).insert(rider);
  }

  /// Delete the given [rider].
  Future<void> deleteRider(Rider rider) => _database.riders.delete().delete(rider);

  /// Get the amount of rides that a [Rider] with the given [id] has attended.
  Future<int> getAttendingCount(int id) async {
    final query = _database.rideAttendees.count(where: (t) => t.riderId.equals(id));

    final result = await query.getSingleOrNull();

    return result ?? 0;
  }

  /// Get the list of riders that satisfy the given [filter].
  Future<List<Rider>> getRiders(RiderFilterOption filter) {
    final query = _database.select(_database.riders);

    query.orderBy([
      (t) => OrderingTerm.asc(t.firstName),
      (t) => OrderingTerm.asc(t.lastName),
      (t) => OrderingTerm.asc(t.alias, nulls: .last),
    ]);

    switch (filter) {
      case .active:
        query.where((t) => t.isActive.equals(true));
      case .inactive:
        query.where((t) => t.isActive.equals(false));
      default:
        break;
    }

    return query.get();
  }

  /// Toggle the [Rider.isActive] state of the given [rider].
  Future<void> setRiderActive(Rider rider, {required bool value}) {
    final update = RidersCompanion(id: Value(rider.id), isActive: Value(value));

    return _database.update(_database.riders).replace(update);
  }

  /// Update the given [rider].
  Future<void> updateRider(Rider rider) async {
    if (await _riderExists(firstName: rider.firstName, lastName: rider.lastName, alias: rider.alias, id: rider.id)) {
      throw RiderExistsException();
    }

    await _database.update(_database.riders).replace(rider);
  }

  /// Check whether a rider exists.
  ///
  /// If [id] is null, this method returns whether a rider exists
  /// with the given [firstName], [lastName] and [alias].
  ///
  /// If [id] is not null, this method returns whether a rider exists
  /// with the given [firstName], [lastName], [alias] and a id
  /// that is *different* from the given id.
  Future<bool> _riderExists({
    required String? alias,
    required String firstName,
    required String lastName,
    int? id,
  }) async {
    final query = _database.riders.count(
      where: (t) => Expression.and([
        t.firstName.equals(firstName),
        t.lastName.equals(lastName),
        t.alias.equalsNullable(alias),
        if (id != null) t.id.equals(id).not(),
      ]),
    );

    final result = await query.getSingleOrNull();

    return result == null;
  }
}
