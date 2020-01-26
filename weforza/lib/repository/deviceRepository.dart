
import 'package:weforza/database/deviceDao.dart';

class DeviceRepository {
  DeviceRepository(this._dao): assert(_dao != null);
  
  final IDeviceDao _dao;

  Future<bool> deviceExists(String device) => _dao.deviceExists(device);

  Future<void> addDevice(String ownerId,String device) => _dao.addDevice(ownerId, device);

  Future<void> removeDevice(String device) => _dao.removeDevice(device);

  Future<void> updateDevice(String ownerId,String oldDevice,String newDevice) => _dao.updateDevice(ownerId, oldDevice, newDevice);

  Future<List<String>> getOwnerDevices(String uuid) => _dao.getOwnerDevices(uuid);
}