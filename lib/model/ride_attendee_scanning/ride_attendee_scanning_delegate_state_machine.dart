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

  /// Dispose of this state machine.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _notifier.dispose();
  }
}
