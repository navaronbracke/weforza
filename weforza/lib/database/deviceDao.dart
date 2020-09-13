import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/device.dart';

///This interface defines a contract to work with member devices.
abstract class IDeviceDao {
  Future<void> addDevice(Device device);

  Future<void> removeDevice(String deviceName);

  Future<void> updateDevice(Device newDevice);

  Future<List<Device>> getOwnerDevices(String ownerId);

  Future<List<Device>> getAllDevices();

  Future<Set<String>> getOwnersOfDevicesWithName(String deviceName);
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
  Future<void> removeDevice(String device) async {
    await _deviceStore.delete(_database,finder: Finder(filter: Filter.equals("deviceName",device)));
  }

  @override
  Future<void> updateDevice(Device newDevice) async {
    await _deviceStore.update(_database, newDevice.toMap(),finder: Finder(
      filter: Filter.byKey(newDevice.creationDate.toIso8601String())
    ));
  }

  @override
  Future<List<Device>> getAllDevices() async {
    final records = await _deviceStore.find(_database);
    return records.map((record) => Device.of(record.key,record.value)).toList();
  }

  @override
  Future<Set<String>> getOwnersOfDevicesWithName(String deviceName) async {
    final records = await _deviceStore.find(
        _database,
        finder: Finder(filter: Filter.equals("deviceName", deviceName))
    );

    //Get the owner directly from the snapshot
    return records.map((RecordSnapshot record) => record["owner"]).toSet();
  }
}