/// @docImport 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
library;

import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';

/// This class represents a state machine for the [RideAttendeeScanningDelegate].
class RideAttendeeScanningDelegateStateMachine {
  /// The internal state machine.
  final _notifier = ValueNotifier<AsyncValue<RideAttendeeScanningState>>(const AsyncData(.requestPermissions));

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  /// Determine whether the scanner should be stopped.
  ///
  /// Returns false if the scanner never started,
  /// or if the scanner has already stopped.
  ///
  /// Returns true otherwise.
  bool get shouldStopScanner {
    // These states happen before the scan is running.
    const beforeScanStates = <RideAttendeeScanningState>{
      .bluetoothDisabled,
      .permissionDenied,
      .requestPermissions,
      .startingScan,
    };

    final currentState = _notifier.value;

    // The scanner never started.
    if (currentState case AsyncData(:final value) when beforeScanStates.contains(value)) {
      return false;
    }

    // The scanner failed to start because of a startup failure,
    // i.e. Bluetooth was off, or the permission was denied.
    //
    // If a `SaveScanResultsException` happened, the scanner has already stopped.
    if (currentState case AsyncError(:final error)
        when error is StartScanException || error is SaveScanResultsException) {
      return false;
    }

    return true;
  }

  /// Get a [ValueListenable] of changes to the state of the state machine.
  ValueListenable<AsyncValue<RideAttendeeScanningState>> get listenable => _notifier;

  /// Switch to the new [state].
  void setState(RideAttendeeScanningState state) {
    if (_isDisposed) {
      return;
    }

    if (_notifier.value case AsyncData(:final value) when value == state) {
      return;
    }

    _notifier.value = AsyncData(state);
  }

  /// Add [error] to the state machine.
  void _setError(Object error) {
    if (_isDisposed) {
      return;
    }

    _notifier.value = AsyncError(error, StackTrace.current);
  }

  /// Add a [SaveScanResultsException] to the state machine.
  void setSaveScanResultsError() => _setError(SaveScanResultsException());

  /// Add a [StartScanException] to the state machine.
  void setStartScanError() => _setError(StartScanException());

  /// Add a [StopScanException] to the state machine.
  void setStopScanError() => _setError(StopScanException());

  /// Dispose of this state machine.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _notifier.dispose();
  }
}
