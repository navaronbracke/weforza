import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This class provides an [AsyncValue] that wraps an underlying computation.
///
/// The underlying computation has the following possible states:
///
/// If the value is `null`, the computation has not been started yet.
/// If the value is an [AsyncLoading], the computation is ongoing.
/// If the value is an [AsyncError], the computation has failed with an error.
/// If the value is an [AsyncValue], the computation has completed successfully.
abstract class AsyncComputationDelegate<T> {
  final _notifier = ValueNotifier<AsyncValue<T>?>(null);

  bool _isDisposed = false;

  bool get mounted => !_isDisposed;

  ValueListenable<AsyncValue<T>?> get stateListenable => _notifier;

  /// Check whether a new computation can be started,
  /// and transition to the [AsyncLoading] state.
  ///
  /// Returns whether the computation can be started.
  @protected
  bool canStartComputation() {
    final state = _notifier.value;

    if (state != null && state is! AsyncError) {
      return false;
    }

    _notifier.value = const AsyncLoading();

    return true;
  }

  /// Reset the computation state back to the idle state.
  void reset() {
    _notifier.value = null;
  }

  /// Set the current state to the done state, using the given [data] as value.
  @protected
  void setDone(T data) {
    if (mounted) {
      _notifier.value = AsyncData(data);
    }
  }

  /// Set the current state to a new [AsyncError]
  /// with the given error and stack trace.
  @protected
  void setError(Object error, StackTrace stackTrace) {
    if (mounted) {
      _notifier.value = AsyncError(error, stackTrace);
    }
  }

  /// Dispose of this delegate.
  @mustCallSuper
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _notifier.dispose();
  }
}
