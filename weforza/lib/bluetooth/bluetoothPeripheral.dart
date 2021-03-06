
import 'dart:ui';

///This class wraps a Bluetooth device's name and id.
class BluetoothPeripheral {
  BluetoothPeripheral({
    required this.id,
    required this.deviceName,
  }): assert(id.isNotEmpty);

  final String id;
  final String deviceName;

  @override
  bool operator ==(Object other) => other is BluetoothPeripheral
      && id == other.id && deviceName == other.deviceName;

  @override
  int get hashCode => hashValues(id, deviceName);
}