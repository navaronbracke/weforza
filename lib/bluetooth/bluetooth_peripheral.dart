/// This class represents a Bluetooth device.
class BluetoothPeripheral {
  BluetoothPeripheral({
    required this.deviceName,
    required this.id,
  });

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
