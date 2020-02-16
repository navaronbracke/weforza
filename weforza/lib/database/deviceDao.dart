import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/device.dart';

///This interface defines a contract to work with member devices.
abstract class IDeviceDao {

  Future<bool> deviceExists(String deviceName);

  Future<void> addDevice(Device device);

  Future<void> removeDevice(String deviceName);

  Future<void> updateDevice(String oldDeviceName,Device newDevice);

  Future<List<Device>> getOwnerDevices(String ownerId);

  Future<List<Device>> getAllDevices();
}
///This class is an implementation of [IDeviceDao].
class DeviceDao implements IDeviceDao {
  DeviceDao(this._database): assert(_database != null);

  ///A reference to the database, which is needed by the Store.
  final Database _database;
  ///A reference to the device store.
  final _deviceStore = DatabaseProvider.deviceStore;

  @override
  Future<void> addDevice(Device device) async {
    await _deviceStore.record(device.name).add(_database, device.toMap());
  }

  @override
  Future<bool> deviceExists(String device) async {
    return await _deviceStore.findFirst(_database,finder: Finder(filter: Filter.byKey(device))) != null;
  }

  @override
  Future<List<Device>> getOwnerDevices(String ownerId) async {
    final records = await _deviceStore.find(_database,finder: Finder(filter: Filter.equals("owner", ownerId)));
    return records.map((record) => Device.of(record.key, record.value)).toList();
  }

  @override
  Future<void> removeDevice(String device) {
    return _deviceStore.delete(_database,finder: Finder(filter: Filter.byKey(device)));
  }

  @override
  Future<void> updateDevice(String oldDeviceName, Device newDevice) async {
    if(!await deviceExists(newDevice.name)){
      await _database.transaction((txn) async {
        await removeDevice(oldDeviceName);
        await addDevice(newDevice);
      });
    }
  }

  @override
  Future<List<Device>> getAllDevices() async {
    final records = await _deviceStore.find(_database);
    return records.map((record) => Device.of(record.key, record.value)).toList();
  }
}