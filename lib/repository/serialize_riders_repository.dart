import 'package:drift/drift.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/export/exportable_rider.dart';
import 'package:weforza/model/export/exportable_rider_key.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

/// This class represents the repository that handles (de)serializing riders.
class SerializeRidersRepository {
  new(this._database) : _deviceRepository = DeviceRepository(_database), _riderRepository = RiderRepository(_database);

  /// The database instance.
  final WeForzaDatabase _database;

  final DeviceRepository _deviceRepository;
  final RiderRepository _riderRepository;

  /// Get the collection of [ExportableRider]s.
  ///
  /// The returned list is sorted on the rider name, alias and active state.
  Future<Iterable<ExportableRider>> getExportableRiders() async {
    final (devices, riders) = await (
      _deviceRepository.getAllDevicesGroupedByOwnerId(),
      _riderRepository.getRiders(.all),
    ).wait;

    final output = [
      for (final rider in riders)
        ExportableRider(
          alias: rider.alias ?? '',
          firstName: rider.firstName,
          lastName: rider.lastName,
          isActive: rider.isActive,
          devices: devices[rider.id] ?? const {},
          lastUpdated: rider.lastUpdated,
        ),
    ];

    output.sort((s1, s2) => s1.compareTo(s2));

    return output;
  }

  /// Save the given exportable [exportedRiders] to disk.
  Future<void> saveExportableRiders(Iterable<ExportableRider> exportedRiders) async {
    final (riderInserts, riderUpdates) = await _computeRiderImports(exportedRiders);

    return _database.transaction(() async {
      await _importRidersWithDevices(riderInserts, riderUpdates);
    });
  }

  /// Compute the rider inserts and updates.
  ///
  /// Returns a record containing the new riders to insert and the updates for existing riders.
  /// Updates to existing riders may include a change to their active status or the addition of new devices.
  ///
  /// If the returned isActive is null, there is no change to the rider's active status.
  /// If the returned newDevices set is empty, there are no new devices for the rider.
  Future<(Iterable<ExportableRider>, Map<int, ({bool? isActive, Set<String> newDevices})>)> _computeRiderImports(
    Iterable<ExportableRider> exportedRiders,
  ) async {
    final (existingRiders, existingDevicesPerRider) = await (
      _riderRepository.getRiders(.all),
      _deviceRepository.getAllDevicesGroupedByOwnerId(),
    ).wait;

    final Map<ExportableRiderKey, Rider> existingRidersByName = {
      for (final rider in existingRiders) .fromRider(rider): rider,
    };

    final List<ExportableRider> riderInserts = [];
    final Map<int, ({bool? isActive, Set<String> newDevices})> riderUpdates = {};

    for (final newRider in exportedRiders) {
      final Rider? existingRider = existingRidersByName[ExportableRiderKey.fromExportedRider(newRider)];

      if (existingRider == null) {
        riderInserts.add(newRider);

        continue;
      }

      if (!newRider.lastUpdated.isAfter(existingRider.lastUpdated)) {
        continue;
      }

      final Set<String> newDevices = switch (existingDevicesPerRider[existingRider.id]) {
        final Set<String> existingDevices when existingDevices.isNotEmpty => newRider.devices.difference(
          existingDevices,
        ),
        _ => newRider.devices,
      };

      final bool? isActive = newRider.isActive == existingRider.isActive ? null : newRider.isActive;

      if (isActive == null && newDevices.isEmpty) {
        continue;
      }

      riderUpdates[existingRider.id] = (isActive: isActive, newDevices: newDevices);
    }

    return (riderInserts, riderUpdates);
  }

  /// Import the given riders and their associated devices into the database.
  ///
  /// New records are created for new riders and new devices.
  /// Existing riders are updated.
  Future<void> _importRidersWithDevices(
    Iterable<ExportableRider> riderInserts,
    Map<int, ({bool? isActive, Set<String> newDevices})> riderUpdates,
  ) async {
    final List<DevicesCompanion> newDevices = [];
    final List<RidersCompanion> updatedRiders = [];

    // Insert the new riders, record their ids and create pending inserts for their devices.
    for (final rider in riderInserts) {
      final int riderId = await _database
          .into(_database.riders)
          .insert(
            RidersCompanion.insert(
              alias: Value(rider.alias),
              firstName: rider.firstName,
              lastName: rider.lastName,
              isActive: Value(rider.isActive),
            ),
          );

      if (rider.devices.isEmpty) {
        continue;
      }

      newDevices.addAll([
        for (final device in rider.devices)
          DevicesCompanion.insert(ownerId: riderId, deviceType: .unknown, name: device),
      ]);
    }

    // For each of the updated riders, queue their own update and queue their new devices for insertion.
    for (final rider in riderUpdates.entries) {
      if (rider.value.isActive case final bool isActive) {
        updatedRiders.add(RidersCompanion(id: Value(rider.key), isActive: Value(isActive)));
      }

      if (rider.value.newDevices.isEmpty) {
        continue;
      }

      newDevices.addAll([
        for (final device in rider.value.newDevices)
          DevicesCompanion.insert(ownerId: rider.key, deviceType: .unknown, name: device),
      ]);
    }

    await _database.batch((batch) {
      for (final rider in updatedRiders) {
        batch.update(_database.riders, rider, where: (t) => t.id.equals(rider.id.value));
      }

      if (newDevices.isNotEmpty) {
        batch.insertAll(_database.devices, newDevices);
      }
    });
  }
}
