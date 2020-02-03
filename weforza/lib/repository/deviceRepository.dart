
import 'package:weforza/database/deviceDao.dart';
import 'package:weforza/model/device.dart';

class DeviceRepository {
  DeviceRepository(this._dao): assert(_dao != null);
  
  final IDeviceDao _dao;

  Future<bool> deviceExists(String device) => _dao.deviceExists(device);

  Future<void> addDevice(Device device) => _dao.addDevice(device);

  Future<void> removeDevice(String device) => _dao.removeDevice(device);

  Future<void> updateDevice(String oldDevice,Device newDevice) => _dao.updateDevice(oldDevice, newDevice);

  Future<List<Device>> getOwnerDevices(String uuid) => _dao.getOwnerDevices(uuid);
}