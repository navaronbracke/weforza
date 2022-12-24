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
///
/// Implementations of this class
/// are typically used with [StateNotifierProvider.autoDispose].
abstract class AsyncComputationNotifier<T>
    extends StateNotifier<AsyncValue<T>?> {
  AsyncComputationNotifier() : super(null);

  /// Check whether a new computation can be started,
  /// and transition to the [AsyncLoading] state.
  ///
  /// Returns whether the computation can be started.
  @protected
  bool canStartComputation() {
    if (state != null && state is! AsyncError) {
      return false;
    }

    state = const AsyncLoading();

    return true;
  }

  /// Reset the computation state back to the idle state.
  void reset() {
    state = null;
  }

  /// Set the current state to a new [AsyncError]
  /// with the given error and stack trace.
  @protected
  void setError(Object error, StackTrace stackTrace) {
    if (mounted) {
      state = AsyncError(error, stackTrace);
    }
  }
}
