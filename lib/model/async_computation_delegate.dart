import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

/// This class provides an [AsyncValue] that wraps an underlying computation.
///
/// The underlying computation has the following possible states:
///
/// If the value is `null`, the computation has not been started yet.
/// If the value is an [AsyncLoading], the computation is ongoing.
/// If the value is an [AsyncError], the computation has failed with an error.
/// If the value is an [AsyncValue], the computation has completed successfully.
abstract class AsyncComputationDelegate<T> {
  final _controller = BehaviorSubject<AsyncValue<T>?>();

  AsyncValue<T>? get currentState => _controller.valueOrNull;

  bool get mounted => !_controller.isClosed;

  Stream<AsyncValue<T>?> get stream => _controller;

  /// Check whether a new computation can be started,
  /// and transition to the [AsyncLoading] state.
  ///
  /// Returns whether the computation can be started.
  @protected
  bool canStartComputation() {
    final state = _controller.valueOrNull;

    if (state != null && state is! AsyncError) {
      return false;
    }

    _controller.add(const AsyncLoading());

    return true;
  }

  /// Reset the computation state back to the idle state.
  void reset() {
    _controller.add(null);
  }

  /// Set the current state to the done state, using the given [data] as value.
  @protected
  void setDone(T data) {
    if (mounted) {
      _controller.add(AsyncData(data));
    }
  }

  /// Set the current state to a new [AsyncError]
  /// with the given error and stack trace.
  @protected
  void setError(Object error, StackTrace stackTrace) {
    if (mounted) {
      _controller.add(AsyncError(error, stackTrace));
    }
  }

  /// Dispose of this delegate.
  @mustCallSuper
  void dispose() {
    _controller.close();
  }
}
