import 'dart:collection';

import 'package:sembast/sembast.dart';
import 'package:weforza/cipher/cipher.dart';
import 'package:weforza/database/database_store_provider.dart';
import 'package:weforza/model/device.dart';

///This interface defines a contract to work with member devices.
abstract class IDeviceDao {
  Future<void> addDevice(Device device);

  Future<void> removeDevice(Device device);

  Future<void> updateDevice(Device newDevice);

  Future<List<Device>> getOwnerDevices(String ownerId);

  Future<bool> deviceExists(String deviceName, String ownerUuid, [DateTime? creationDate]);

  ///This groups all the devices together that belong to the same owner id.
  ///Note that device names can occur in multiple lists, as multiple people can have a device with the same name.
  Future<HashMap<String, Set<String>>> getAllDevicesGroupedByOwnerId();

  Future<List<Device>> getAllDevices();
}
///This class is an implementation of [IDeviceDao].
class DeviceDao implements IDeviceDao {
  DeviceDao(this._database, this._deviceStore, this._memberStore, this._cipher);

  DeviceDao.withProvider(Database database, DatabaseStoreProvider storeProvider, Cipher cipher): this(
    database,
    storeProvider.deviceStore,
    storeProvider.memberStore,
    cipher,
  );

  ///A reference to the database, which is needed by the Store.
  final Database _database;
  ///A reference to the device store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  ///A reference to the member store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;

  /// The [Cipher] in charge of encryption.
  final Cipher _cipher;

  @override
  Future<void> addDevice(Device device) async {
    await _database.transaction((txn) async {
      await _deviceStore.record(device.creationDate.toIso8601String()).add(txn, device.encrypt(_cipher));
      await _memberStore.update(
        txn,
        { "lastUpdated": DateTime.now().toIso8601String() },
        finder: Finder(
          filter: Filter.byKey(device.ownerId),
        ),
      );
    });
  }

  @override
  Future<List<Device>> getOwnerDevices(String ownerId) async {
    final records = await _deviceStore.find(_database,finder: Finder(filter: Filter.equals("owner", ownerId)));
    return records.map((record) => Device.decrypt(record.key,record.value, _cipher)).toList();
  }

  @override
  Future<void> removeDevice(Device device) async {
    await _database.transaction((txn) async {
      await _deviceStore.delete(
        txn,
        finder: Finder(
          filter: Filter.and(<Filter>[
            Filter.equals("deviceName",device.name),
            Filter.equals("owner",device.ownerId),
          ]),
        ),
      );

      await _memberStore.update(
        txn,
        { "lastUpdated": DateTime.now().toIso8601String() },
        finder: Finder(
          filter: Filter.byKey(device.ownerId),
        ),
      );
    });
  }

  @override
  Future<void> updateDevice(Device newDevice) async {
    await _database.transaction((txn) async {
      await _deviceStore.update(txn, newDevice.encrypt(_cipher),finder: Finder(
          filter: Filter.byKey(newDevice.creationDate.toIso8601String())
      ));
      await _memberStore.update(
        txn,
        { "lastUpdated": DateTime.now().toIso8601String() },
        finder: Finder(
          filter: Filter.byKey(newDevice.ownerId),
        ),
      );
    });
  }

  @override
  Future<bool> deviceExists(String deviceName, String ownerUuid, [DateTime? creationDate]) async {
    final List<Filter> filters = [
      Filter.equals("deviceName", deviceName),
      Filter.equals("owner", ownerUuid),
      if(creationDate != null)
        Filter.notEquals(Field.key, creationDate.toIso8601String())
    ];

    return await _deviceStore.findFirst(
      _database,
      finder: Finder(
        filter: Filter.and(filters),
      ),
    ) != null;
  }

  @override
  Future<HashMap<String, Set<String>>> getAllDevicesGroupedByOwnerId() async {
    final List<RecordSnapshot<String, Map<String, dynamic>>> devices = await _deviceStore.find(_database);

    final HashMap<String,Set<String>> collection = HashMap();

    devices.forEach((record) {
      final String device = record["deviceName"] as String;
      final String ownerUuid = record["owner"] as String;

      if(collection.containsKey(ownerUuid)){
        collection[ownerUuid]!.add(device);
      }else{
        collection[ownerUuid] = Set.of(<String>[device]);
      }
    });

    return collection;
  }

  @override
  Future<List<Device>> getAllDevices() async {
    final records = await _deviceStore.find(_database);
    return records.map((record) => Device.decrypt(record.key,record.value, _cipher)).toList();
  }
}