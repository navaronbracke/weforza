import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';

// TODO: regression test for scanning twice in a row not showing the scanning progress bar the second time
// TODO: fix the iOS CBCenteralManager not initializing properly the first time scanning is requested

/// This provider provides the Bluetooth scanner.
///
/// This provider is not an `autoDispose` provider,
/// as the Bluetooth scanner can be reused multiple times.
/// It is disposed using [ProviderRef.onDispose] when the [ProviderContainer] is disposed.
final bluetoothProvider = Provider<BluetoothDeviceScanner>((ref) {
  final scanner = BluetoothDeviceScannerImpl();

  ref.onDispose(scanner.dispose);

  return scanner;
});
