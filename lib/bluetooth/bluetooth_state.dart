/// The different states of the Bluetooth adapter.
enum BluetoothState {
  /// The Bluetooth adapter is currently disabled.
  off,

  /// The Bluetooth adapter is currently enabled.
  on,

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
  factory BluetoothState.fromValue(String? value) {
    switch (value) {
      case 'off':
        return off;
      case 'on':
        return on;
      case 'turningOff':
        return turningOff;
      case 'turningOn':
        return turningOn;
      case 'unauthorized':
        return unauthorized;
      case 'unavailable':
        return unavailable;
      case 'unknown':
        return unknown;
      default:
        throw ArgumentError.value(value);
    }
  }
}
