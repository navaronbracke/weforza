/// The different states of the Bluetooth adapter.
enum BluetoothState {
  /// The state of the Bluetooth adapter is currently unknown.
  unknown,

  /// The device does not support Bluetooth.
  unavailable,

  /// Access to the Bluetooth adapter is prohibited.
  unauthorized,

  /// The Bluetooth adapter is currently turning on.
  turningOn,

  /// The Bluetooth adapter is currently enabled.
  on,

  /// The Bluetooth adapter is currently turning off.
  turningOff,

  /// The Bluetooth adapter is currently disabled.
  off
}
