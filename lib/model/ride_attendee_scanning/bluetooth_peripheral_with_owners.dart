import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/database/database.dart';

/// This class represents a [BluetoothPeripheral] with a list of possible [owners].
class BluetoothPeripheralWithOwners {
  const new(this.device, this.owners);

  /// The Bluetooth peripheral itself.
  final BluetoothPeripheral device;

  /// The list of possible owners for [device].
  final List<Rider> owners;
}
