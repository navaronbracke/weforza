import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;
import 'package:weforza/utils/debounce_timer.dart';

/// This class represents a delegate that handles deferred saving of a value.
abstract class DeferredSaveDelegate<T> with DebounceTimer {
  /// The default constructor.
  DeferredSaveDelegate({required T initialValue, this._debounceDuration = const Duration(seconds: 1)})
    : _notifier = ValueNotifier(initialValue);

  /// The notifier that manages the value that should be saved.
  final ValueNotifier<T> _notifier;

  final Duration _debounceDuration;

  bool _isDisposed = false;

  /// Get the [ValueListenable] of changes to the current value.
  ValueListenable<T> get listenable => _notifier;

  void _handleOnValueChanged(T value) {
    if (_isDisposed || _notifier.value == value) {
      return;
    }

    _notifier.value = value;

    onValueCommitted(value);
  }

  /// Save the underlying value, which has now been comitted.
  void onValueCommitted(T value);

  /// Set the current value to [value].
  void onValueChanged(T value) {
    debounce(_debounceDuration, () => _handleOnValueChanged(value));
  }

  /// Dispose of this delegate.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    cancelDebounce();
    _notifier.dispose();
  }
}
