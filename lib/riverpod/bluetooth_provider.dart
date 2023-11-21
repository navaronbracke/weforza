import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/native_service/bluetooth_adapter.dart';

/// This provider provides the Bluetooth scanner.
final bluetoothProvider = Provider.autoDispose<BluetoothDeviceScanner>((ref) {
  final scanner = BluetoothAdapter();

  ref.onDispose(scanner.dispose);

  return scanner;
});
