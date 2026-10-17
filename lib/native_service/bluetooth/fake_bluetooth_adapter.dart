import 'package:weforza/bluetooth/bluetooth_device_scan_options.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';
import 'package:weforza/native_service/bluetooth/bluetooth_device_scanner.dart';

/// A fake [BluetoothDeviceScanner] implementation for use with Simulators and in tests.
final class FakeBluetoothAdapter implements BluetoothDeviceScanner {
  @override
  Future<bool> get bluetoothIsOn async => true;

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> requestBluetoothScanPermission() async => true;

  @override
  Stream<BluetoothPeripheral> get scanResultsStream async* {
    final duplicateOwner = BluetoothPeripheral(id: '1', deviceName: 'rudy1');
    final duplicateDevice = BluetoothPeripheral(id: '2', deviceName: 'duplicate_device');
    final ownedByMultiple = BluetoothPeripheral(id: '3', deviceName: 'shared1');
    final emptyDeviceName = BluetoothPeripheral(id: '4', deviceName: '');
    final blankDeviceName = BluetoothPeripheral(id: '5', deviceName: '  ');

    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(seconds: 2));

      if (i == 1) {
        yield* Stream.error(ArgumentError('some error'), StackTrace.current);
      }

      if (i == 2 || i == 3) {
        yield duplicateDevice;
      }

      if (i == 4 || i == 5) {
        yield duplicateOwner;
      }

      if (i == 6) {
        yield ownedByMultiple;
      }

      if (i == 7) {
        yield emptyDeviceName;
      }

      if (i == 8) {
        yield blankDeviceName;
      }

      // Emit unknown devices as fallback.
      yield BluetoothPeripheral(id: '$i', deviceName: 'Device $i');
    }
  }

  @override
  Future<void> startScan(BluetoothDeviceScanOptions options) async {}

  @override
  Stream<BluetoothState> get stateStream => Stream.value(.on);

  @override
  Future<void> stopScan() async {}
}
