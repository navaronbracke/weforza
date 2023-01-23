import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// This class represents a delegate that handles deferred saving of a value.
abstract class DeferredSaveDelegate<T> {
  /// The default constructor.
  DeferredSaveDelegate({
    required T initialValue,
    Duration debounce = const Duration(seconds: 1),
  }) : _controller = BehaviorSubject.seeded(initialValue) {
    _subscription = _controller.debounceTime(debounce).listen(
      (T value) {
        if (_controller.isClosed) {
          return;
        }

        saveValue(value);
      },
    );
  }

  /// The controller that manages the value that should be saved.
  final BehaviorSubject<T> _controller;

  /// The debounce subscription.
  StreamSubscription<T>? _subscription;

  /// Get the current value.
  T get currentValue => _controller.value;

  /// Get the stream of changes to the current value.
  Stream<T> get stream => _controller;

  /// Set the current value to [value].
  void onValueChanged(T value) {
    if (!_controller.isClosed && _controller.value != value) {
      _controller.add(value);
    }
  }

  /// Save the given value.
  void saveValue(T value);

  /// Dispose of this delegate.
  void dispose() {
    if (_controller.isClosed) {
      return;
    }

    _subscription?.cancel();
    _subscription = null;
    _controller.close();
  }
}
