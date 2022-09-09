import 'package:sembast/sembast.dart';

import 'package:weforza/extensions/date_extension.dart';
import 'package:weforza/model/device.dart';

/// This class defines an interface to work with devices.
abstract class DeviceDao {
  /// Add the given [device].
  Future<void> addDevice(Device device);

  /// Check whether a device exists.
  ///
  /// If [creationDate] is null, this method returns whether a device exists
  /// with the given [deviceName] and [ownerUuid].
  ///
  /// If [creationDate] is not null, this method returns whether a device exists
  /// with the given [deviceName], [ownerUuid] and a creation date
  /// that is *different* from the given creation date.
  Future<bool> deviceExists(
    String deviceName,
    String ownerUuid, [
    DateTime? creationDate,
  ]);

  /// Get the list of all devices.
  Future<List<Device>> getAllDevices();

  /// Get the list of all devices and group them together on their [Device.ownerId].
  ///
  /// Returns a Map that contains the names of the devices per owner uuid.
  /// A single device name can occur more than once in the entire map,
  /// if multiple owners contain a device with the same name.
  Future<Map<String, Set<String>>> getAllDevicesGroupedByOwnerId();

  /// Get the devices of an [ownerId].
  Future<List<Device>> getOwnerDevices(String ownerId);

  /// Remove the given [device].
  Future<void> removeDevice(Device device);

  /// Update a device.
  Future<void> updateDevice(Device newDevice);
}

/// This class represents the default implementation of [DeviceDao].
class DeviceDaoImpl implements DeviceDao {
  DeviceDaoImpl(this._database, this._deviceStore, this._memberStore);

  /// A reference to the database.
  final Database _database;

  /// A reference to the device store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  /// A reference to the member store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;

  /// Update the `lastUpdated` field of the owner of a given device.
  Future<void> _updateOwnerLastUpdated(String ownerId, DatabaseClient txn) {
    return _memberStore.record(ownerId).update(
      txn,
      {'lastUpdated': DateTime.now().toUtc().toStringWithoutMilliseconds()},
    );
  }

  @override
  Future<void> addDevice(Device device) {
    return _database.transaction((txn) async {
      await _deviceStore
          .record(device.creationDate.toIso8601String())
          .add(txn, device.toMap());

      await _updateOwnerLastUpdated(device.ownerId, txn);
    });
  }

  @override
  Future<bool> deviceExists(
    String deviceName,
    String ownerUuid, [
    DateTime? creationDate,
  ]) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('deviceName', deviceName),
        Filter.equals('owner', ownerUuid),
        if (creationDate != null)
          Filter.notEquals(Field.key, creationDate.toIso8601String())
      ]),
    );

    return await _deviceStore.findFirst(_database, finder: finder) != null;
  }

  @override
  Future<List<Device>> getAllDevices() async {
    final records = await _deviceStore.find(_database);

    return records.map((r) => Device.of(r.key, r.value)).toList();
  }

  @override
  Future<Map<String, Set<String>>> getAllDevicesGroupedByOwnerId() async {
    final devices = await _deviceStore.find(_database);

    final collection = <String, Set<String>>{};

    for (final record in devices) {
      final String device = record['deviceName'] as String;
      final String ownerUuid = record['owner'] as String;

      if (collection.containsKey(ownerUuid)) {
        collection[ownerUuid]!.add(device);
      } else {
        collection[ownerUuid] = <String>{device};
      }
    }

    return collection;
  }

  @override
  Future<List<Device>> getOwnerDevices(String ownerId) async {
    final records = await _deviceStore.find(
      _database,
      finder: Finder(filter: Filter.equals('owner', ownerId)),
    );

    return records.map((r) => Device.of(r.key, r.value)).toList();
  }

  @override
  Future<void> removeDevice(Device device) {
    return _database.transaction((txn) async {
      await _deviceStore.delete(
        txn,
        finder: Finder(
          filter: Filter.and([
            Filter.equals('deviceName', device.name),
            Filter.equals('owner', device.ownerId),
          ]),
        ),
      );

      await _updateOwnerLastUpdated(device.ownerId, txn);
    });
  }

  @override
  Future<void> updateDevice(Device newDevice) {
    return _database.transaction((txn) async {
      final key = newDevice.creationDate.toIso8601String();

      await _deviceStore.record(key).update(txn, newDevice.toMap());

      await _updateOwnerLastUpdated(newDevice.ownerId, txn);
    });
  }
}
