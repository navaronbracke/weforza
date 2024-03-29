import 'dart:async';

import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';

/// This class defines an interface for a Bluetooth device scanner.
abstract class BluetoothDeviceScanner {
  /// Returns whether the Bluetooth adapter is currently on.
  Future<bool> get bluetoothIsOn;

  /// Get the current scanning state.
  bool get isScanning;

  /// Get the stream of changes to the scanning state.
  Stream<bool> get isScanningStream;

  /// Get the stream of changes to the Bluetooth adapter's state.
  Stream<BluetoothState> get state;

  /// Request permission to use the Bluetooth adapter.
  ///
  /// Returns whether permission was granted.
  Future<bool> requestBluetoothScanPermission();

  /// Scan for Bluetooth devices.
  /// The [scanDurationInSeconds] indicates the length of the scan in seconds.
  ///
  /// Returns a stream of scan results.
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds);

  /// Stop a running scan.
  Future<void> stopScan();

  /// Dispose of this scanner.
  ///
  /// After this scanner was disposed, it cannot be used anymore.
  Future<void> dispose();
}
