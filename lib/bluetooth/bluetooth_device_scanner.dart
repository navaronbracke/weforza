import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';

/// This class defines an interface for a bluetooth scanner.
abstract class BluetoothDeviceScanner {
  /// Check whether bluetooth is enabled.
  Future<bool> isBluetoothEnabled();

  /// Get the current scanning state.
  bool get isScanning;

  /// Get the stream of changes to the scanning state.
  Stream<bool> get isScanningStream;

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
  bool get isScanning => _fBlInstance.isScanning;

  @override
  Stream<bool> get isScanningStream => _fBlInstance.isScanningStream;

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) {
    return _fBlInstance
        .scan(scanMode: ScanMode.balanced, timeout: Duration(seconds: scanDurationInSeconds))
        .map((result) => BluetoothPeripheral(id: result.device.id.id, deviceName: result.device.name));
  }

  @override
  Future<void> stopScan() => _fBlInstance.stopScan();

  @override
  void dispose() {
    // If the scan could not be stopped, there is nothing that can be done.
    unawaited(stopScan().catchError((_) {}));
  }
}
