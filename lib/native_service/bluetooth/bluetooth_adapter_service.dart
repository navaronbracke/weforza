import 'dart:async';

import 'package:weforza/bluetooth/bluetooth_device_scan_options.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';
import 'package:weforza/native_service/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/native_service/bluetooth/hardware_bluetooth_adapter.dart';
import 'package:weforza/utils/stream_transformers.dart';

/// This class represents a service for interacting with the Bluetooth adapter on the device.
///
/// It supports an injectable [BluetoothDeviceScanner] implementation,
/// for use in tests or mocking on Simulators that lack the required hardware.
final class BluetoothAdapterService {
  /// Creates an instance of [BluetoothAdapterService].
  ///
  /// The underlying [BluetoothDeviceScanner] defaults to a [HardwareBluetoothAdapter].
  new({this._scanner = const HardwareBluetoothAdapter()});

  /// Whether the [BluetoothDeviceScanner] is currently scanning for devices.
  bool _isScanning = false;

  /// The controller that manages the value
  /// that indicates whether a Bluetooth device scan is currently in progress.
  final StreamController<bool> _isScanningController = StreamController<bool>.broadcast();

  /// The underlying Bluetooth device scanner implementation.
  final BluetoothDeviceScanner _scanner;

  /// Get the [Stream] that emits the current [BluetoothState] of the Bluetooth adapter.
  Stream<BluetoothState> get bluetoothAdapterStateStream => _scanner.stateStream;

  /// Whether the Bluetooth adapter is currently turned on.
  Future<bool> get bluetoothAdapterIsOn => _scanner.bluetoothIsOn;

  /// Whether the [BluetoothDeviceScanner] is currently scanning for devices.
  bool get isScanning => _isScanning;

  /// Get the [Stream] that emits the current [isScanning] state as it changes.
  Stream<bool> get isScanningStream async* {
    yield _isScanning;
    yield* _isScanningController.stream;
  }

  /// Handle the cancellation of the [StreamSubscription] for the [Stream] of [scanForDevices].
  void _onScanStreamCanceled() {
    _setScanningState(false);
    unawaited(_scanner.stopScan());
  }

  /// Set the current scanning state value and, if needed, also signal the scan abort.
  void _setScanningState(bool value) {
    if (_isScanning == value) {
      return;
    }

    _isScanning = value;

    if (!_isScanningController.isClosed) {
      _isScanningController.add(value);
    }
  }

  /// Request permission to perform a Bluetooth scan.
  ///
  /// Returns whether the permission to perform a Bluetooth scan was granted.
  Future<bool> requestBluetoothScanPermission() => _scanner.requestBluetoothScanPermission();

  /// Start a scan for Bluetooth devices.
  ///
  /// Returns the [Stream] of discovered [BluetoothPeripheral]s.
  ///
  /// To stop the scan that was started, call [StreamSubscription.cancel] on the subscriptions for this stream.
  Stream<BluetoothPeripheral> scanForDevices() async* {
    if (isScanning) {
      throw StateError('Another scan is already in progress.');
    }

    _setScanningState(true);

    const BluetoothDeviceScanOptions options = BluetoothDeviceScanOptions(scanMode: .balanced);

    try {
      await _scanner.startScan(options);
    } catch (error) {
      // Abort if the scan fails to start.
      _setScanningState(false);

      rethrow;
    }

    // The underlying stream itself does not stop until the subscription is cancelled.
    // When it does, signal the adapter that the scan should be canceled.
    yield* _scanner.scanResultsStream.transform(OnCancelTransformer(_onScanStreamCanceled));
  }

  /// Dispose of this Bluetooth adapter.
  ///
  /// If a scan is currently running, it is stopped.
  ///
  /// It is up to the caller to first cancel any [StreamSubscription] from [scanForDevices],
  /// before calling this method.
  Future<void> dispose() async {
    if (_isScanningController.isClosed) {
      return;
    }

    // Try to stop any running scan, just in case.
    if (isScanning) {
      await _scanner.stopScan();
    }

    await _isScanningController.close();
  }
}
