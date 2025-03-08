import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/bluetooth/bluetooth_device_scan_options.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';
import 'package:weforza/native_service/native_service.dart';

/// This class represents a [NativeService] for the Bluetooth adapter on the device.
final class BluetoothAdapter extends NativeService implements BluetoothDeviceScanner {
  /// The controller that manages the value
  /// that indicates whether a Bluetooth device scan is currently in progress.
  final BehaviorSubject<bool> _isScanningController = BehaviorSubject.seeded(false);

  /// The controller that manages the stop scan signal emitter.
  /// This signal emitter will emit a signal when a Bluetooth device scan should be manually aborted.
  final PublishSubject<void> _stopScanSignalEmitter = PublishSubject();

  @override
  Future<bool> get bluetoothIsOn async {
    final bool? result = await methodChannel.invokeMethod<bool>('isBluetoothOn');

    return result ?? false;
  }

  @override
  bool get isScanning => _isScanningController.value;

  @override
  Stream<bool> get isScanningStream => _isScanningController;

  /// Cached broadcast stream for Bluetooth adapter state events.
  /// Caching this stream allows listeners to individually subscribe to events.
  Stream<BluetoothState>? _stateStream;

  @override
  Stream<BluetoothState> get state async* {
    yield BluetoothState.fromValue(await methodChannel.invokeMethod<String>('getBluetoothAdapterState'));

    _stateStream ??= bluetoothStateChannel
        .receiveBroadcastStream()
        .cast<String?>()
        .map(BluetoothState.fromValue)
        .doOnCancel(() => _stateStream = null);

    yield* _stateStream!;
  }

  @override
  Future<bool> requestBluetoothScanPermission() async {
    final bool? result = await methodChannel.invokeMethod<bool>('requestBluetoothScanPermission');

    return result ?? false;
  }

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) async* {
    if (isScanning) {
      throw StateError('Another scan is already in progress.');
    }

    _isScanningController.add(true);

    final List<Stream> abortScanTriggers = [
      _stopScanSignalEmitter,
      Rx.timer(null, Duration(seconds: scanDurationInSeconds)),
    ];

    const BluetoothDeviceScanOptions options = BluetoothDeviceScanOptions(scanMode: BluetoothScanMode.balanced);

    try {
      await methodChannel.invokeMethod<void>('startBluetoothScan', options.toMap());
    } catch (error) {
      // If the scan fails to start, rollback the stop trigger and abort.
      if (!_isScanningController.isClosed) {
        _stopScanSignalEmitter.add(null);
        _isScanningController.add(false);
      }

      rethrow;
    }

    yield* bluetoothDeviceDiscoveryChannel
        .receiveBroadcastStream()
        .takeUntil(Rx.merge(abortScanTriggers))
        .map((event) {
          // The binary messenger sends things back as `Object?`.
          // If the event is a `Map`,
          // it does not have type information and comes back as `Map<Object?, Object?>`.
          // Cast it using `Map.cast()` to at least recover the type of the key.
          // The values are still `Object?`, though.
          final Map<String, Object?> eventMap = (event as Map<Object?, Object?>).cast<String, Object?>();

          return BluetoothPeripheral.fromMap(eventMap);
        })
        .doOnDone(stopScan);
  }

  @override
  Future<void> stopScan() async {
    if (_isScanningController.isClosed || !isScanning) {
      return;
    }

    await methodChannel.invokeMethod<void>('stopBluetoothScan');

    if (_isScanningController.isClosed) {
      return;
    }

    _stopScanSignalEmitter.add(null);
    _isScanningController.add(false);
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
    super.dispose();
  }
}
