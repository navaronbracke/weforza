
import 'dart:collection';

import 'package:weforza/database/deviceDao.dart';
import 'package:weforza/model/device.dart';

class DeviceRepository {
  DeviceRepository(this._dao): assert(_dao != null);
  
  final IDeviceDao _dao;

  Future<void> addDevice(Device device) => _dao.addDevice(device);

  Future<void> removeDevice(Device device) => _dao.removeDevice(device);

  Future<void> updateDevice(Device newDevice) => _dao.updateDevice(newDevice);

  Future<List<Device>> getOwnerDevices(String uuid) => _dao.getOwnerDevices(uuid);

  Future<bool> deviceExists(String deviceName, String ownerUuid, [DateTime creationDate]) => _dao.deviceExists(deviceName, ownerUuid, creationDate);

  Future<HashMap<String,List<String>>> getOwnersOfAllDevices() => _dao.getAllOwnersGroupedByDeviceName();
}