import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';

/// This provider provides the bluetooth scanner.
final bluetoothProvider = Provider<BluetoothDeviceScanner>(
  (_) => BluetoothDeviceScannerImpl(),
);
