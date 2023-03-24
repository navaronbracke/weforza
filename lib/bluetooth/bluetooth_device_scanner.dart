import 'dart:async';

import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';

/// This class defines an interface for a bluetooth scanner.
abstract class BluetoothDeviceScanner {
  /// Check whether bluetooth is enabled.
  Future<bool> isBluetoothEnabled();

  /// Get the current scanning state.
  bool get isScanning;

  /// Get the stream of changes to the scanning state.
  Stream<bool> get isScanningStream;

  /// Get the stream of changes to the Bluetooth adapter's state.
  Stream<BluetoothState> get state;

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
  final BehaviorSubject<bool> _isScanningController = BehaviorSubject.seeded(false);

  @override
  bool get isScanning => _isScanningController.value;

  @override
  Stream<bool> get isScanningStream => _isScanningController;

  /*

  @override
  Future<bool> isBluetoothEnabled() async {
    if (Platform.isAndroid) {
      return _fBlInstance.isOn;
    }

    // On iOS, the `CBCentralManager` might still be in the `BluetoothState.unknown` state
    // at the time of requesting the state of the Bluetooth adapter.
    // If the adapter indicates that is it on, return early.
    // If it is not, defer to the actual state of the adapter to find out the real state.
    if (Platform.isIOS) {
      final bool isOn = await _fBlInstance.isOn;

      if (isOn) {
        return true;
      }

      final Completer<bool> completer = Completer();
      StreamSubscription<BluetoothState>? subscription;

      subscription = _fBlInstance.state.listen(
        (state) {
          switch (state) {
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

    throw UnsupportedError('Only Android and iOS are supported.');
  }

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

    _isScanningController.close();
  }
}
