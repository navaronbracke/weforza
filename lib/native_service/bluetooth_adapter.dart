/// @docImport 'package:flutter_test/flutter_test.dart';
library;

import 'dart:async';

import 'package:weforza/bluetooth/bluetooth_device_scan_options.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';
import 'package:weforza/native_service/native_service.dart';

/// This class represents a [NativeService] for the Bluetooth adapter on the device.
///
/// To mock the underlying channel pass the [methodChannel] to [TestDefaultBinaryMessenger.setMockMethodCallHandler]
/// To mock the underlying event channels pass the [bluetoothStateChannel] and [bluetoothDeviceDiscoveryChannel]
/// to [TestDefaultBinaryMessenger.setMockStreamHandler].
final class BluetoothAdapter extends NativeService implements BluetoothDeviceScanner {
  /// Whether the Bluetooth adapter is currently scanning for devices.
  bool _isScanning = false;

  /// The controller that manages the value
  /// that indicates whether a Bluetooth device scan is currently in progress.
  final StreamController<bool> _isScanningController = StreamController<bool>.broadcast();

  /// The controller that manages the stop scan signal.
  /// This signal emitter will emit a signal when a Bluetooth device scan should be manually aborted.
  final StreamController<void> _stopScanSignalEmitter = StreamController<void>.broadcast();

  void _setScanningState(bool value) {
    _isScanning = value;

    if (!_isScanningController.isClosed) {
      _isScanningController.add(value);
    }

    // Signal that the scan will be stopped.
    if (!_stopScanSignalEmitter.isClosed && !value) {
      _stopScanSignalEmitter.add(null);
    }
  }

  @override
  Future<bool> get bluetoothIsOn async {
    final bool? result = await methodChannel.invokeMethod<bool>('isBluetoothOn');

    return result ?? false;
  }

  @override
  bool get isScanning => _isScanning;

  @override
  Stream<bool> get isScanningStream async* {
    yield _isScanning;
    yield* _isScanningController.stream;
  }

  @override
  Stream<BluetoothState> get stateStream async* {
    yield BluetoothState.fromValue(await methodChannel.invokeMethod<String>('getBluetoothAdapterState'));
    yield* bluetoothStateChannel.receiveBroadcastStream().cast<String?>().map(BluetoothState.fromValue);
  }

  @override
  Future<bool> requestBluetoothScanPermission() async {
    return await methodChannel.invokeMethod<bool>('requestBluetoothScanPermission') ?? false;
  }

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) async* {
    if (isScanning) {
      throw StateError('Another scan is already in progress.');
    }

    _setScanningState(true);

    const BluetoothDeviceScanOptions options = BluetoothDeviceScanOptions(scanMode: .balanced);

    try {
      await methodChannel.invokeMethod<void>('startBluetoothScan', options.toMap());
    } catch (error) {
      // If the scan fails to start, rollback the stop trigger and abort.
      _setScanningState(false);

      rethrow;
    }

    final List<Stream<void>> abortScanTriggers = [
      _stopScanSignalEmitter.stream,
      Stream.fromFuture(Future.delayed(Duration(seconds: scanDurationInSeconds))),
    ];

    yield* bluetoothDeviceDiscoveryChannel
        .receiveBroadcastStream()
        .transform(_takeUntilTransformer(abortTrigger))
        // The binary messenger sends `Object?` across the sink boundary, but the events are untyped Maps,
        // since the Maps cannot carry strict types across the boundary.
        // Cast the events to the expected type afterwards.
        .where((event) => event is Map<Object?, Object?>)
        .cast<Map<String, Object?>>()
        .map(BluetoothPeripheral.fromMap)
        .transform(_onDoneTransformer(stopScan));
  }

  @override
  Future<void> stopScan() async {
    if (_isScanningController.isClosed || !isScanning) {
      return;
    }

    await methodChannel.invokeMethod<void>('stopBluetoothScan');

    _setScanningState(false);
  }

  /// Dispose of this Bluetooth adapter.
  ///
  /// If a scan is currently running, it is stopped.
  @override
  Future<void> dispose() async {
    if (_isScanningController.isClosed) {
      return;
    }

    // Try to stop any running scan.
    if (isScanning) {
      await stopScan();
    }

    await _isScanningController.close();
    await _stopScanSignalEmitter.close();
  }
}
