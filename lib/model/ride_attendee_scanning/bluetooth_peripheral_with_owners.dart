import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/model/rider/rider.dart';

/// This class represents a [BluetoothPeripheral] with a list of possible [owners].
class BluetoothPeripheralWithOwners {
  const BluetoothPeripheralWithOwners(this.device, this.owners);

  /// The Bluetooth peripheral itself.
  final BluetoothPeripheral device;

  /// The list of possible owners for [device].
  final List<Rider> owners;
}
