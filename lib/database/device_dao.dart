/// @docImport 'package:weforza/database/database.dart';
library;

import 'package:weforza/model/device/device.dart';

/// This class represents the interface for working with devices from the [Database].
abstract class DeviceDao {
  /// Add the given [device].
  Future<void> addDevice(Device device);

  /// Get the list of all devices.
  Future<List<Device>> getAllDevices();

  /// Get the list of all devices and group them together on their [Device.ownerId].
  ///
  /// Returns a Map that contains the names of the devices per owner uuid.
  /// A single device name can occur more than once in the entire map,
  /// if multiple owners contain a device with the same name.
  Future<Map<String, Set<String>>> getAllDevicesGroupedByOwnerId();

  /// Get the devices of an [ownerId].
  Future<List<Device>> getOwnerDevices(String ownerId);

  /// Remove the given [device].
  Future<void> removeDevice(Device device);

  /// Update a device.
  Future<void> updateDevice(Device newDevice);
}
