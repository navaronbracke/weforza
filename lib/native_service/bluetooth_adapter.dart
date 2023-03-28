import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/bluetooth/bluetooth_device_scan_options.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';
import 'package:weforza/native_service/native_service.dart';

/// This class represents a [NativeService] for the Bluetooth adapter on the device.
class BluetoothAdapter extends NativeService implements BluetoothDeviceScanner {
  /// The controller that manages the value
  /// that indicates whether a Bluetooth device scan is currently in progress.
  final BehaviorSubject<bool> _isScanningController = BehaviorSubject.seeded(false);

  /// The controller that manages the stop scan signal emitter.
  /// This signal emitter will emit a signal when a Bluetooth device scan should be manually aborted.
  final PublishSubject<void> _stopScanSingalEmitter = PublishSubject();

  @override
  Future<bool> get bluetoothIsOn async {
    final bool? result = await methodChannel.invokeMethod<bool>('isBluetoothOn');

    if (result != null) {
      return result;
    }

    // If the Bluetooth adapter returned null, it is neither on or off,
    // but in an intermediate state (i.e. it is turning on or off).
    // In that case, wait for it to turn on or off.
    final Completer<bool> completer = Completer();

    StreamSubscription<BluetoothState>? subscription;

    subscription = state.listen(
      (value) {
        switch (value) {
          case BluetoothState.off:
          case BluetoothState.turningOff:
            // Complete with the value and cancel the subscription.
            if (!completer.isCompleted) {
              subscription?.cancel();
              subscription = null;
              completer.complete(false);
            }
            break;
          case BluetoothState.on:
            // Complete with the value and cancel the subscription.
            if (!completer.isCompleted) {
              subscription?.cancel();
              subscription = null;
              completer.complete(true);
            }
            break;
          case BluetoothState.unauthorized:
            // Complete with the error and cancel the subscription.
            if (!completer.isCompleted) {
              subscription?.cancel();
              subscription = null;
              completer.completeError(
                StateError('Access to Bluetooth was not authorized.'),
                StackTrace.current,
              );
            }
            break;
          case BluetoothState.unavailable:
            // Complete with the error and cancel the subscription.
            if (!completer.isCompleted) {
              subscription?.cancel();
              subscription = null;
              completer.completeError(
                UnsupportedError('Bluetooth is not supported on this device.'),
                StackTrace.current,
              );
            }
            break;
          case BluetoothState.unknown:
          case BluetoothState.turningOn:
          case BluetoothState.resetting:
            // If the state is unknown, wait for it to resolve.
            // If the state is turning on, wait for it to switch to `BluetoothState.on`.
            break;
        }
      },
      cancelOnError: true,
      onError: (error, stackTrace) {
        // Complete with the error and cancel the subscription.
        if (!completer.isCompleted) {
          subscription?.cancel();
          subscription = null;
          completer.completeError(error, stackTrace);
        }
      },
    );

    return completer.future;
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
      _stopScanSingalEmitter,
      Rx.timer(null, Duration(seconds: scanDurationInSeconds)),
    ];

    const BluetoothDeviceScanOptions options = BluetoothDeviceScanOptions(scanMode: BluetoothScanMode.balanced);

    try {
      await methodChannel.invokeMethod<void>('startBluetoothScan', options.toMap());
    } catch (error) {
      // If the scan fails to start, rollback the stop trigger and abort.
      if (!_isScanningController.isClosed) {
        _stopScanSingalEmitter.add(null);
        _isScanningController.add(false);
      }

      rethrow;
    }

    yield* bluetoothDeviceDiscoveryChannel.receiveBroadcastStream().takeUntil(Rx.merge(abortScanTriggers)).map((event) {
      // The binary messenger sends things back as `dynamic`.
      // If the event is a `Map`,
      // it does not have type information and comes back as `Map<Object?, Object?>`.
      // Cast it using `Map.cast()` to at least recover the type of the key.
      // The values are still `Object?`, though.
      final Map<String, Object?> eventMap = (event as Map<Object?, Object?>).cast<String, Object?>();

      return BluetoothPeripheral.fromMap(eventMap);
    }).doOnDone(stopScan);
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

    _stopScanSingalEmitter.add(null);
    _isScanningController.add(false);
  }

  @override
  void dispose() {
    if (_isScanningController.isClosed) {
      return;
    }

    // Try to stop any running scan. If the scan could not be stopped,
    // there is no proper way to handle the error at this point.
    if (isScanning) {
      unawaited(stopScan().catchError((_) {}));
    }

    _isScanningController.close();
    _stopScanSingalEmitter.close();
    super.dispose();
  }
}
