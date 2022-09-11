import 'package:weforza/model/device_type.dart';

/// A device is a piece of hardware that is owned by a person.
/// Each device has a [creationDate], a [name], an [ownerId] and a [type].
class Device {
  /// The default constructor.
  Device({
    required this.creationDate,
    required this.name,
    required this.ownerId,
    this.type = DeviceType.unknown,
  }) : assert(ownerId.isNotEmpty && name.isNotEmpty);

  /// Create a device from the given [key] and [values].
  factory Device.of(String key, Map<String, dynamic> values) {
    assert(key.isNotEmpty);

    return Device(
      creationDate: DateTime.parse(key),
      name: values['deviceName'] as String,
      ownerId: values['owner'] as String,
      type: DeviceType.fromTypeIndex(values['type'] as int),
    );
  }

  /// The creation date of this device.
  /// This creation date is not indicative of the actual creation date
  /// of the physical hardware item.
  /// It is only used internally as the key for the device record.
  final DateTime creationDate;

  /// The human-readable name of the device.
  final String name;

  /// The UUID of the owner of this device.
  final String ownerId;

  /// The type of this device.
  final DeviceType type;

  static final RegExp deviceNameRegex = RegExp(r'^[^,]{1,40}$');

  static const int nameMaxLength = 40;

  /// Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {'deviceName': name, 'owner': ownerId, 'type': type.typeIndex};
  }

  @override
  bool operator ==(Object other) {
    return other is Device && name == other.name && ownerId == other.ownerId;
  }

  @override
  int get hashCode => Object.hash(name, ownerId);
}
