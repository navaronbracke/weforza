import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';

/// This class defines an interface for a bluetooth scanner.
abstract class BluetoothDeviceScanner {
  /// Check whether bluetooth is enabled.
  Future<bool> isBluetoothEnabled();

  /// Get the stream of changes to the scanning state.
  Stream<bool> get isScanning;

  /// Scan for bluetooth devices.
  /// The [scanDurationInSeconds] indicates the length of the scan in seconds.
  ///
  /// Returns a stream of scan results.
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds);

  /// Stop a running scan.
  Future<void> stopScan();

  /// Dispose of this scanner.
  void dispose();
}

class BluetoothDeviceScannerImpl implements BluetoothDeviceScanner {
  final FlutterBluePlus _fBlInstance = FlutterBluePlus.instance;

  @override
  Future<bool> isBluetoothEnabled() => _fBlInstance.isOn;

  @override
  Stream<bool> get isScanning => _fBlInstance.isScanning;

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) =>
      _fBlInstance
          .scan(
            allowDuplicates: false,
            scanMode: ScanMode.balanced,
            timeout: Duration(seconds: scanDurationInSeconds),
          )
          .map(
            (result) => BluetoothPeripheral(
              id: result.device.id.id,
              // Trim the whitespace off.
              // This could otherwise cause matching issues later on.
              deviceName: result.device.name.trim(),
            ),
          );

  @override
  Future<void> stopScan() => _fBlInstance.stopScan();

  @override
  void dispose() {
    stopScan().catchError((_) {
      // If the scan could not be stopped, there is nothing that can be done.
    });
  }
}
