/// This class represents a delegate for managing the scan duration option
/// in the settings page.
abstract class ScanDurationDelegate {
  /// Get the minimum allowed value.
  double get minScanDuration;

  /// Get the maximum allowed value.
  double get maxScanDuration;

  /// Get the current value.
  double get currentScanDuration;

  /// Update the value.
  void onScanDurationChanged(double newValue);
}
