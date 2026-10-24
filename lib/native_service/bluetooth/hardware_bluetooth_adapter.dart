/// @docImport 'package:flutter_test/flutter_test.dart';
library;

import 'package:weforza/bluetooth/bluetooth_device_scan_options.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/bluetooth/bluetooth_state.dart';
import 'package:weforza/native_service/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/native_service/native_service.dart';

/// An implementation of [BluetoothDeviceScanner] that interacts with the hardware Bluetooth adapter on the device.
///
/// To mock the underlying channel pass the [methodChannel] to [TestDefaultBinaryMessenger.setMockMethodCallHandler]
/// To mock the underlying event channels pass the [bluetoothStateChannel] and [bluetoothDeviceDiscoveryChannel]
/// to [TestDefaultBinaryMessenger.setMockStreamHandler].
final class HardwareBluetoothAdapter extends NativeService implements BluetoothDeviceScanner {
  const new();

  @override
  Future<bool> get bluetoothIsOn async => await methodChannel.invokeMethod<bool>('isBluetoothOn') ?? false;

  @override
  Stream<BluetoothPeripheral> get scanResultsStream {
    return bluetoothDeviceDiscoveryChannel
        .receiveBroadcastStream()
        // The events are actually untyped Maps,
        // since the Maps cannot carry strict types across the boundary.
        // Filter out the non-Maps and cast the remaining events to the expected Map type.
        .where((event) => event is Map<Object?, Object?>)
        .cast<Map<String, Object?>>()
        .map(BluetoothPeripheral.fromMap);
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
  Future<void> startScan(BluetoothDeviceScanOptions options) async {
    return await methodChannel.invokeMethod<void>('startBluetoothScan', options.toMap());
  }

  @override
  Future<void> stopScan() async {
    await methodChannel.invokeMethod<void>('stopBluetoothScan');
  }

  @override
  Future<void> dispose() {
    // The underlying event channels are not disposed themselves.
    // Instead the subscriptions towards them are cancelled,
    // which triggers disposal when the listeners are removed.
    //
    // The method channel cannot be disposed, as it is stateless.
    // Instead, just stop any ongoing scan, in case the caller forgot to do so.
    return stopScan();
  }
}
