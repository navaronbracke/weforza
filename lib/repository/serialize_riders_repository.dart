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
  Future<Iterable<ExportableRider>> getSerializableRiders() async {
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
  Future<void> saveSerializableRiders(Iterable<ExportableRider> exportedRiders) async {
    final (existingRiders, existingDevicesPerRider) = await (
      _riderRepository.getRiders(.all),
      _deviceRepository.getAllDevicesGroupedByOwnerId(),
    ).wait;

    final Map<ExportableRiderKey, Rider> existingRidersByName = {
      for (final rider in existingRiders) .fromRider(rider): rider,
    };

    final Set<ExportableRider> riderInserts = {};
    final Map<int, ({bool isActive, Set<String> newDevices})> riderUpdates = {};

    for (final newRider in exportedRiders) {
      final key = ExportableRiderKey.fromExportedRider(newRider);
      final Rider? existingRider = existingRidersByName[key];

      if (existingRider == null) {
        riderInserts.add(newRider);

        continue;
      }

      if (newRider.lastUpdated.isAfter(existingRider.lastUpdated)) {
        final Set<String> newDevices = newRider.devices.difference(
          existingDevicesPerRider[existingRider.id] ?? const {},
        );

        if (newRider.isActive != existingRider.isActive || newDevices.isNotEmpty) {
          riderUpdates[existingRider.id] = (isActive: newRider.isActive, newDevices: newDevices);
        }
      }
    }

    final List<DevicesCompanion> newDevices = [];

    for (final rider in riderInserts) {
      final int riderId = await _database
          .into(_database.riders)
          .insert(
            RidersCompanion(
              alias: Value(rider.alias),
              firstName: Value(rider.firstName),
              lastName: Value(rider.lastName),
              isActive: Value(rider.isActive),
            ),
          );

      newDevices.addAll([
        for (final device in rider.devices)
          DevicesCompanion(ownerId: Value(riderId), deviceType: const Value(.unknown), name: Value(device)),
      ]);
    }

    await _database.batch((batch) {
      for (final rider in riderUpdates.entries) {
        batch.update(
          _database.riders,
          RidersCompanion(id: Value(rider.key), isActive: Value(rider.value.isActive)),
          where: (t) => t.id.equals(rider.key),
        );
      }

      batch.insertAll(_database.devices, newDevices);
    });
  }
}
