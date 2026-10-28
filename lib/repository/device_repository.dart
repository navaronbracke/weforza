import 'package:drift/drift.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/exceptions/exceptions.dart';

class DeviceRepository {
  const new(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// Add the given [device].
  ///
  /// Throws a [DeviceExistsException] if a device with the same name and owner already exists.
  Future<Device> addDevice(DevicesCompanion device) async {
    if (await _deviceExists(device.name.value, device.ownerId.value)) {
      throw DeviceExistsException();
    }

    return _database.transaction(() async {
      final int id = await _database.into(_database.devices).insert(device);

      await _updateOwnerLastUpdated(device.ownerId.value);

      return (_database.devices.select()..where((t) => t.id.equals(id))).getSingle();
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
      final rowsAffected = await _database.delete(_database.devices).delete(device);

      if (rowsAffected > 0) {
        await _updateOwnerLastUpdated(device.ownerId);
      }
    });
  }

  /// Update a device.
  ///
  /// Throws a [DeviceExistsException] if a device with the same name and owner already exists.
  Future<Device> updateDevice(DevicesCompanion device) async {
    if (await _deviceExists(device.name.value, device.ownerId.value, deviceId: device.id.value)) {
      throw DeviceExistsException();
    }

    return _database.transaction(() async {
      await _database.update(_database.devices).replace(device);

      await _updateOwnerLastUpdated(device.ownerId.value);

      return (_database.devices.select()..where((t) => t.id.equals(device.id.value))).getSingle();
    });
  }

  /// Check whether a device exists.
  ///
  /// If [deviceId] is null, this method returns whether a device exists
  /// with the given [deviceName] and [ownerId].
  ///
  /// If [deviceId] is not null, this method returns whether a device exists
  /// with the given [deviceName], [ownerId] and an id that is *different*
  /// from the given id.
  Future<bool> _deviceExists(String deviceName, int ownerId, {int? deviceId}) async {
    final query = _database.devices.count(
      where: (t) {
        return Expression.and([
          t.name.equals(deviceName),
          t.ownerId.equals(ownerId),
          if (deviceId != null) t.id.equals(deviceId).not(),
        ]);
      },
    );

    final result = await query.getSingleOrNull();

    // The device exists if at least one row is returned.
    return result != null && result > 0;
  }

  Future<void> _updateOwnerLastUpdated(int ownerId) async {
    // Use a companion for a partial update, as opposed to a full Rider model.
    final update = RidersCompanion(lastUpdated: Value(DateTime.now()));

    await (_database.update(_database.riders)..where((t) => t.id.equals(ownerId))).write(update);
  }
}
