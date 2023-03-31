import 'dart:collection';

import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/device.dart';

///This interface defines a contract to work with member devices.
abstract class IDeviceDao {
  Future<void> addDevice(Device device);

  Future<void> removeDevice(Device device);

  Future<void> updateDevice(Device newDevice);

  Future<List<Device>> getOwnerDevices(String ownerId);

  Future<bool> deviceExists(String deviceName, String ownerUuid, [DateTime creationDate]);

  ///This groups all the devices together that belong to the same owner id.
  ///Note that device names can occur in multiple lists, as multiple people can have a device with the same name.
  Future<HashMap<String, Set<String>>> getAllDevicesGroupedByOwnerId();

  Future<List<Device>> getAllDevices();
}
///This class is an implementation of [IDeviceDao].
class DeviceDao implements IDeviceDao {
  DeviceDao(this._database, this._deviceStore):
        assert(_database != null && _deviceStore != null);

  DeviceDao.withProvider(ApplicationDatabase provider):
        this(provider.getDatabase(), provider.deviceStore);

  ///A reference to the database, which is needed by the Store.
  final Database _database;
  ///A reference to the device store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  @override
  Future<void> addDevice(Device device) async {
    await _deviceStore.record(device.creationDate.toIso8601String()).add(_database, device.toMap());
  }

  @override
  Future<List<Device>> getOwnerDevices(String ownerId) async {
    final records = await _deviceStore.find(_database,finder: Finder(filter: Filter.equals("owner", ownerId)));
    return records.map((record) => Device.of(record.key,record.value)).toList();
  }

  @override
  Future<void> removeDevice(Device device) async {
    await _deviceStore.delete(
        _database,
        finder: Finder(
          filter: Filter.and(<Filter>[
            Filter.equals("deviceName",device.name),
            Filter.equals("owner",device.ownerId),
          ]),
        ),
    );
  }

  @override
  Future<void> updateDevice(Device newDevice) async {
    await _deviceStore.update(_database, newDevice.toMap(),finder: Finder(
      filter: Filter.byKey(newDevice.creationDate.toIso8601String())
    ));
  }

  @override
  Future<bool> deviceExists(String deviceName, String ownerUuid, [DateTime creationDate]) async {
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
        collection[ownerUuid].add(device);
      }else{
        collection[ownerUuid] = Set.of(<String>[device]);
      }
    });

    return collection;
  }

  @override
  Future<List<Device>> getAllDevices() async {
    final records = await _deviceStore.find(_database);
    return records.map((record) => Device.of(record.key,record.value)).toList();
  }
}