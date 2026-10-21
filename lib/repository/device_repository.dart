import 'package:weforza/database/database.dart';
import 'package:weforza/database/devices.dart';

class DeviceRepository {
  const DeviceRepository(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// Add the given [device].
  Future<void> addDevice(Device device);

  /// Get the list of all devices.
  Future<List<Device>> getAllDevices() => _database.select(_database.devices).get();

  /// Get the list of all devices and group them together on their [Device.ownerId].
  ///
  /// Returns a Map that contains the names of the devices per owner uuid.
  /// A single device name can occur more than once in the entire map,
  /// if multiple owners contain a device with the same name.
  Future<Map<String, Set<String>>> getAllDevicesGroupedByOwnerId();

  /// Get the devices of an [ownerId].
  Future<List<Device>> getOwnerDevices(int ownerId);

  /// Remove the given [device].
  Future<void> removeDevice(Device device);

  /// Update a device.
  Future<void> updateDevice(Device newDevice);
}
