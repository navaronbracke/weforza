import 'package:weforza/database/device_dao.dart';
import 'package:weforza/model/device.dart';

class DeviceRepository {
  DeviceRepository(this._dao);

  final DeviceDao _dao;

  Future<void> addDevice(Device device) => _dao.addDevice(device);

  Future<bool> deviceExists(
    String deviceName,
    String ownerUuid, [
    DateTime? creationDate,
  ]) {
    return _dao.deviceExists(deviceName, ownerUuid, creationDate);
  }

  Future<List<Device>> getAllDevices() => _dao.getAllDevices();

  Future<List<Device>> getOwnerDevices(String uuid) {
    return _dao.getOwnerDevices(uuid);
  }

  Future<void> removeDevice(Device device) => _dao.removeDevice(device);

  Future<void> updateDevice(Device newDevice) => _dao.updateDevice(newDevice);
}
