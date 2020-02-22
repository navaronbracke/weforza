
import 'package:weforza/database/deviceDao.dart';
import 'package:weforza/model/device.dart';

class DeviceRepository {
  DeviceRepository(this._dao): assert(_dao != null);
  
  final IDeviceDao _dao;

  Future<bool> deviceExists(Device device,[String ownerId]) => _dao.deviceExists(device,ownerId);

  Future<void> addDevice(Device device) => _dao.addDevice(device);

  Future<void> removeDevice(String device) => _dao.removeDevice(device);

  Future<void> updateDevice(Device newDevice) => _dao.updateDevice(newDevice);

  Future<List<Device>> getOwnerDevices(String uuid) => _dao.getOwnerDevices(uuid);

  Future<List<Device>> getAllDevices() => _dao.getAllDevices();
}