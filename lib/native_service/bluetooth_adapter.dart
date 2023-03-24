import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
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
  bool get isScanning => _isScanningController.value;

  @override
  Stream<bool> get isScanningStream => _isScanningController;

  @override
  Future<bool> requestBluetoothScanPermission() async {
    final bool? result = await methodChannel.invokeMethod<bool>('requestBluetoothScanPermission');

    return result ?? false;
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
