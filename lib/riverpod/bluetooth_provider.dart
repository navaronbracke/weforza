import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/native_service/bluetooth_adapter.dart';

/// This provider provides the Bluetooth scanner.
///
/// This provider is not an `autoDispose` provider,
/// as the Bluetooth scanner can be reused multiple times.
/// It is disposed using [ProviderRef.onDispose] when the [ProviderContainer] is disposed.
final bluetoothProvider = Provider<BluetoothDeviceScanner>((ref) {
  final scanner = BluetoothAdapter();

  ref.onDispose(scanner.dispose);

  return scanner;
});
