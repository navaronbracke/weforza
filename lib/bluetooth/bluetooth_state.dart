/// The different states of the Bluetooth adapter.
enum BluetoothState {
  /// The Bluetooth adapter is currently disabled.
  off,

  /// The Bluetooth adapter is currently enabled.
  on,

  /// The Bluetooth adapter is currently resetting.
  resetting,

  /// The Bluetooth adapter is currently turning off.
  turningOff,

  /// The Bluetooth adapter is currently turning on.
  turningOn,

  /// Access to the Bluetooth adapter is prohibited.
  unauthorized,

  /// The device does not support Bluetooth.
  unavailable,

  /// The state of the Bluetooth adapter is currently unknown.
  unknown;

  /// Create a [BluetoothState] from the given [value].
  factory fromValue(String? value) => switch (value) {
    'off' => off,
    'on' => on,
    'resetting' => resetting,
    'turningOff' => turningOff,
    'turningOn' => turningOn,
    'unauthorized' => unauthorized,
    'unavailable' => unavailable,
    'unknown' => unknown,
    _ => throw ArgumentError.value(value),
  };
}
