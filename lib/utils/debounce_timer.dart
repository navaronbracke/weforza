import 'dart:async' show Timer;

/// A mixin for operations that require a debounce mechanism.
mixin DebounceTimer {
  Timer? _debounceTimer;

  /// Debounce the execution of the provided [action] by the specified [duration].
  void debounce(Duration duration, void Function() action) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, action);
  }

  /// Cancel any pending debounce action.
  void cancelDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}
