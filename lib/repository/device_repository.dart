import 'package:drift/drift.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/exceptions/exceptions.dart';

class DeviceRepository {
  const DeviceRepository(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// Add the given [device].
  ///
  /// Throws a [DeviceExistsException] if a device with the same name and owner already exists.
  Future<void> addDevice(DevicesCompanion device) async {
    if (await _deviceExists(device.name.value, device.ownerId.value)) {
      throw DeviceExistsException();
    }

    return _database.transaction(() async {
      await _database.into(_database.devices).insert(device);

      await _updateOwnerLastUpdated(device.ownerId.value);
    });
  }

  /// Get the list of all devices.
  Future<List<Device>> getAllDevices() => _database.select(_database.devices).get();

  /// Get the list of all devices and group them together on their [Device.ownerId].
  ///
  /// Returns a [Map] that contains the [Device.name] of the devices per [Device.ownerId].
  /// A single device name can occur more than once in the entire map,
  /// if multiple owners contain a device with the same name.
  Future<Map<int, Set<String>>> getAllDevicesGroupedByOwnerId() async {
    final collection = <int, Set<String>>{};

    for (final device in await getAllDevices()) {
      if (collection.containsKey(device.ownerId)) {
        collection[device.ownerId]?.add(device.name);
      } else {
        collection[device.ownerId] = <String>{device.name};
      }
    }

    return collection;
  }

  /// Get the devices of an [ownerId].
  Future<List<Device>> getOwnerDevices(int ownerId) {
    return (_database.select(_database.devices)..where((t) => t.ownerId.equals(ownerId))).get();
  }

  /// Delete the given [device].
  Future<void> deleteDevice(Device device) {
    return _database.transaction(() async {
      await _database.delete(_database.devices).delete(device);

      await _updateOwnerLastUpdated(device.ownerId);
    });
  }

  /// Update a device.
  ///
  /// Throws a [DeviceExistsException] if a device with the same name and owner already exists.
  Future<void> updateDevice(DevicesCompanion device) async {
    if (await _deviceExists(device.name.value, device.ownerId.value, device.creationDate.value)) {
      throw DeviceExistsException();
    }

    return _database.transaction(() async {
      await _database.update(_database.devices).replace(device);

      await _updateOwnerLastUpdated(device.ownerId.value);
    });
  }

  /// Check whether a device exists.
  ///
  /// If [creationDate] is null, this method returns whether a device exists
  /// with the given [deviceName] and [ownerId].
  ///
  /// If [creationDate] is not null, this method returns whether a device exists
  /// with the given [deviceName], [ownerId] and a creation date
  /// that is *different* from the given creation date.
  Future<bool> _deviceExists(String deviceName, int ownerId, [DateTime? creationDate]) async {
    final query = _database.devices.count(
      where: (t) => Expression.and([
        t.name.equals(deviceName),
        t.ownerId.equals(ownerId),
        if (creationDate != null) t.creationDate.equals(creationDate).not(),
      ]),
    );

    final result = await query.getSingleOrNull();

    return result == null;
  }

  Future<void> _updateOwnerLastUpdated(int ownerId) async {
    final update = RidersCompanion(lastUpdated: Value(DateTime.now()));

    await (_database.update(_database.riders)..where((t) => t.id.equals(ownerId))).write(update);
  }
}
