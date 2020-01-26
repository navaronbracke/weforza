import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';

///This interface defines a contract to work with member devices.
abstract class IDeviceDao {

  Future<bool> deviceExists(String device);

  Future<void> addDevice(String ownerId,String device);

  Future<void> removeDevice(String device);

  Future<void> updateDevice(String ownerId,String oldDevice,String newDevice);

  Future<List<String>> getOwnerDevices(String ownerId);
}
///This class is an implementation of [IDeviceDao].
class DeviceDao implements IDeviceDao {
  DeviceDao(this._database): assert(_database != null);

  ///A reference to the database, which is needed by the Store.
  final Database _database;
  ///A reference to the device store.
  final _deviceStore = DatabaseProvider.deviceStore;

  @override
  Future<void> addDevice(String ownerId, String device) async {
    if(!await deviceExists(device)){
      await _deviceStore.record(device).add(_database, { "ownerId": ownerId });
    }
  }

  @override
  Future<bool> deviceExists(String device) async {
    return await _deviceStore.findFirst(_database,finder: Finder(filter: Filter.byKey(device))) != null;
  }

  @override
  Future<List<String>> getOwnerDevices(String ownerId) {
    return _deviceStore.findKeys(_database,finder: Finder(filter: Filter.equals("ownerId", ownerId)));
  }

  @override
  Future<void> removeDevice(String device) {
    return _deviceStore.delete(_database,finder: Finder(filter: Filter.byKey(device)));
  }

  @override
  Future<void> updateDevice(String ownerId, String oldDevice, String newDevice) async {
    if(!await deviceExists(newDevice)){
      await _database.transaction((txn) async {
        await removeDevice(oldDevice);
        await addDevice(ownerId, newDevice);
      });
    }
  }
}