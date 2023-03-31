/// This class represents a delegate for managing the scan duration option
/// in the settings page.
abstract class ScanDurationDelegate {
  /// Get the minimum allowed value.
  double get min;

  /// Get the maximum allowed value.
  double get max;

  /// Get the current value.
  double get value;

  /// Update the value.
  void onChanged(double newValue);
}
