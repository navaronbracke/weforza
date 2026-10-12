import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;
import 'package:weforza/utils/debounce_timer.dart';

/// This class represents a delegate that manages a changeable query string,
/// that is debounced for updates.
class DebounceSearchDelegate with DebounceTimer {
  /// The default constructor.
  DebounceSearchDelegate({this._debounceTime = const Duration(milliseconds: 500)});

  final Duration _debounceTime;
  final _notifier = ValueNotifier('');

  bool _isDisposed = false;

  void _handleOnValueChanged(String value) {
    if (_isDisposed || _notifier.value == value) {
      return;
    }

    _notifier.value = value;
  }

  /// Update the search query.
  void onQueryChanged(String value) {
    debounce(_debounceTime, () => _handleOnValueChanged(value));
  }

  /// Get the [ValueListenable] of search query changes.
  ValueListenable<String> get searchQueryListenable => _notifier;

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
