import 'package:weforza/model/device_type.dart';

/// This class represents the model to add or edit a device.
class DevicePayload {
  /// The default constructor.
  const DevicePayload({
    required this.creationDate,
    required this.name,
    required this.ownerId,
    required this.type,
  });

  /// The local creation date of this device,
  /// or null if the device should be created.
  final DateTime? creationDate;

  /// The name of this device.
  final String name;

  /// The UUID of the owner of the device.
  final String ownerId;

  /// The type of the device.
  final DeviceType type;
}
