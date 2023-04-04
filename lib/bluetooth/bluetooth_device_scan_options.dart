/// This class represents the scan options for a Bluetooth device scan.
class BluetoothDeviceScanOptions {
  const BluetoothDeviceScanOptions({
    this.scanMode = BluetoothScanMode.lowLatency,
  });

  /// The scan mode for the scan.
  final BluetoothScanMode scanMode;

  /// Convert this object to a map.
  Map<String, Object?> toMap() {
    return {
      'androidScanMode': scanMode.androidScanMode,
    };
  }
}

/// The scan mode for a Bluetooth device scan.
enum BluetoothScanMode {
  /// Start a scan in a balanced mode,
  /// which provides a good trade-off between power consumption and latency.
  ///
  /// See also:
  /// https://developer.android.com/reference/android/bluetooth/le/ScanSettings#SCAN_MODE_BALANCED
  balanced(androidScanMode: 1),

  /// Start a scan with low latency between results.
  ///
  /// See also:
  /// https://developer.android.com/reference/android/bluetooth/le/ScanSettings#SCAN_MODE_LOW_LATENCY
  lowLatency(androidScanMode: 2),

  /// Start a scan in low power mode.
  ///
  /// See also:
  /// https://developer.android.com/reference/android/bluetooth/le/ScanSettings#SCAN_MODE_LOW_POWER
  lowPower(androidScanMode: 0),

  /// Passively listen to incoming scan results, without explicitly starting a scan.
  ///
  /// See also:
  /// https://developer.android.com/reference/android/bluetooth/le/ScanSettings#SCAN_MODE_OPPORTUNISTIC
  opportunistic(androidScanMode: -1);

  const BluetoothScanMode({required this.androidScanMode});

  /// The integer that corresponds to the Android specific scan mode.
  final int androidScanMode;
}
