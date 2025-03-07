import 'package:sembast/sembast.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/database/device_dao.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/extensions/date_extension.dart';
import 'package:weforza/model/device/device.dart';

/// This class represents the sembast implementation of [DeviceDao].
class SembastDeviceDao implements DeviceDao {
  SembastDeviceDao(this._database);

  /// A reference to the database.
  final Database _database;

  /// A reference to the device store.
  final _deviceStore = DatabaseTables.device;

  /// A reference to the rider store.
  final _riderStore = DatabaseTables.rider;

  /// Check whether a device exists.
  ///
  /// If [creationDate] is null, this method returns whether a device exists
  /// with the given [deviceName] and [ownerUuid].
  ///
  /// If [creationDate] is not null, this method returns whether a device exists
  /// with the given [deviceName], [ownerUuid] and a creation date
  /// that is *different* from the given creation date.
  Future<bool> _deviceExists(String deviceName, String ownerUuid, [DateTime? creationDate]) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('deviceName', deviceName),
        Filter.equals('owner', ownerUuid),
        if (creationDate != null) Filter.notEquals(Field.key, creationDate.toIso8601String()),
      ]),
    );

    return await _deviceStore.findFirst(_database, finder: finder) != null;
  }

  /// Update the `lastUpdated` field of the owner of a given device.
  Future<void> _updateOwnerLastUpdated(String ownerId, DatabaseClient txn) {
    return _riderStore.record(ownerId).update(txn, {'lastUpdated': DateTime.now().toStringWithoutMilliseconds()});
  }

  @override
  Future<void> addDevice(Device device) async {
    if (await _deviceExists(device.name, device.ownerId)) {
      throw DeviceExistsException();
    }

    return _database.transaction((txn) async {
      await _deviceStore.record(device.creationDate.toIso8601String()).add(txn, device.toMap());

      await _updateOwnerLastUpdated(device.ownerId, txn);
    });
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
    final records = await _deviceStore.find(_database, finder: Finder(filter: Filter.equals('owner', ownerId)));

    return records.map((r) => Device.of(r.key, r.value)).toList();
  }

  @override
  Future<void> removeDevice(Device device) {
    return _database.transaction((txn) async {
      await _deviceStore.delete(
        txn,
        finder: Finder(
          filter: Filter.and([Filter.equals('deviceName', device.name), Filter.equals('owner', device.ownerId)]),
        ),
      );

      await _updateOwnerLastUpdated(device.ownerId, txn);
    });
  }

  @override
  Future<void> updateDevice(Device device) async {
    if (await _deviceExists(device.name, device.ownerId, device.creationDate)) {
      throw DeviceExistsException();
    }

    return _database.transaction((txn) async {
      final key = device.creationDate.toIso8601String();

      await _deviceStore.record(key).update(txn, device.toMap());

      await _updateOwnerLastUpdated(device.ownerId, txn);
    });
  }
}
