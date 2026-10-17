import 'package:weforza/bluetooth/bluetooth_device_scan_options.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';

/// An interface for a Bluetooth device scanner implementation.
abstract interface class BluetoothDeviceScanner {
  /// Returns whether the Bluetooth adapter is currently on.
  Future<bool> get bluetoothIsOn;

  /// Get a [Stream] for the scan results of Bluetooth devices.
  ///
  /// Returns a [Stream] of scanned [BluetoothPeripheral]s.
  ///
  /// See also:
  ///   * [startScan] to actually start the underlying scan process.
  Stream<BluetoothPeripheral> get scanResultsStream;

  /// Get a [Stream] for the Bluetooth adapter's state changes.
  Stream<BluetoothState> get stateStream;

  /// Request permission to use the Bluetooth adapter.
  ///
  /// Returns whether permission was granted.
  Future<bool> requestBluetoothScanPermission();

  /// Start scanning for Bluetooth devices.
  ///
  /// The given [options] can be used to configure the scan behavior.
  Future<void> startScan(BluetoothDeviceScanOptions options);

  /// Stop a running scan.
  Future<void> stopScan();

  /// Dispose of this scanner.
  ///
  /// After this scanner was disposed, it cannot be used anymore.
  Future<void> dispose();
}
