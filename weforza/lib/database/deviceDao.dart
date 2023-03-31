import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/device.dart';

///This interface defines a contract to work with member devices.
abstract class IDeviceDao {

  Future<bool> deviceExists(Device device,[String ownerId]);

  Future<void> addDevice(Device device);

  Future<void> removeDevice(String deviceName);

  Future<void> updateDevice(Device newDevice);

  Future<List<Device>> getOwnerDevices(String ownerId);

  Future<List<Device>> getAllDevices();

  Future<Device> getDeviceWithName(String deviceName);
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
  Future<bool> deviceExists(Device device,[String ownerId]) async {
    final record = await _deviceStore.findFirst(
        _database,
        finder: Finder(
            filter: Filter.equals("deviceName", device.name)
        ),
    );

    if(record == null) return false;//No device with this name

    //If an owner ID is given and the device we found has the same owner ID,
    //then it doesn't exist. This only happens when we are editing a device and
    //the device name was unchanged.
    if(ownerId != null && ownerId.isNotEmpty){
      final device = Device.of(record.key, record.value);
      return device.ownerId != ownerId;
    }

    //The device record was found and we are not editing, thus the owner is never the same person.
    return true;
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
  Future<Device> getDeviceWithName(String deviceName) async {
    final finder = Finder(filter: Filter.equals("deviceName", deviceName));
    final record = await _deviceStore.findFirst(_database, finder: finder);
    return record == null ? null : Device.of(record.key,record.value);
  }
}