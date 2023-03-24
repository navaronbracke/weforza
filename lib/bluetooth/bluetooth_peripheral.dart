/// This class represents a Bluetooth device.
class BluetoothPeripheral {
  /// The default constructor.
  BluetoothPeripheral({
    required this.deviceName,
    required this.id,
  });

  /// Create a [BluetoothPeripheral] from the given [map].
  factory BluetoothPeripheral.fromMap(Map<String, Object?> map) {
    return BluetoothPeripheral(
      deviceName: map['deviceName'] as String,
      id: map['deviceId'] as String,
    );
  }

  /// The name of the device.
  final String deviceName;

  /// The id of the device, as exposed by the raw scan result.
  final String id;

  @override
  bool operator ==(Object other) {
    return other is BluetoothPeripheral && id == other.id && deviceName == other.deviceName;
  }

  @override
  int get hashCode => Object.hash(id, deviceName);
}
