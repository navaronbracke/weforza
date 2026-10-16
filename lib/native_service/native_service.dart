import 'package:flutter/services.dart';

/// This class represents a service that connetcs to services that are defined on the native side.
///
/// It exposes a [MethodChannel] for calling the underlying native service.
///
/// It also exposes several [EventChannel]s for events that are emitted by the underlying native service.
base class NativeService {
  const NativeService();

  /// The [MethodChannel] that is used to call methods on the native service.
  final MethodChannel methodChannel = const MethodChannel('be.weforza.app/methods');

  /// The [EventChannel] that is used to receive events from the Bluetooth device discovery stream.
  final EventChannel bluetoothDeviceDiscoveryChannel = const EventChannel('be.weforza.app/bluetooth_device_discovery');

  /// The [EventChannel] that is used to receive events from the Bluetooth adapter state.
  final EventChannel bluetoothStateChannel = const EventChannel('be.weforza.app/bluetooth_state');
}
