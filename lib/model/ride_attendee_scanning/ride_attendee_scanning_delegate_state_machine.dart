import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';

/// This class represents a state machine for the [RideAttendeeScanningDelegate].
class RideAttendeeScanningDelegateStateMachine {
  /// The internal state machine.
  final _controller = BehaviorSubject.seeded(
    RideAttendeeScanningState.requestPermissions,
  );

  /// Get the current state of the state machine.
  RideAttendeeScanningState get currentState => _controller.value;

  /// Returns whether the state machine is closed and cannot be used anymore.
  bool get isClosed => _controller.isClosed;

  /// Determine whether the scanner should be stopped.
  ///
  /// Returns false if the scanner never started,
  /// or if the scanner has already stopped.
  ///
  /// Returns true otherwise.
  bool get shouldStopScanner {
    // These states happen before the scan is running.
    final beforeScanStates = <RideAttendeeScanningState>{
      RideAttendeeScanningState.bluetoothDisabled,
      RideAttendeeScanningState.permissionDenied,
      RideAttendeeScanningState.requestPermissions,
      RideAttendeeScanningState.startingScan,
    };

    final state = _controller.valueOrNull;
    final stateError = _controller.errorOrNull;

    // The scanner never started.
    if (stateError == null && beforeScanStates.contains(state)) {
      return false;
    }

    // The scanner failed to start because of a startup failure,
    // i.e. Bluetooth was off, or the permission were denied.
    if (stateError is StartScanException) {
      return false;
    }

    // By the time a `SaveScanResultsException` occurs,
    // the scanner has already stopped.
    if (stateError is SaveScanResultsException) {
      return false;
    }

    return true;
  }

  /// Get a [Stream] of changes to the state of the state machine.
  Stream<RideAttendeeScanningState> get stateStream => _controller;

  /// Switch to the new [state].
  void setState(RideAttendeeScanningState state) {
    if (isClosed || _controller.value == state) {
      return;
    }

    _controller.add(state);
  }

  /// Add [error] to the state machine.
  void _setError(Object error) {
    if (!isClosed) {
      _controller.addError(error);
    }
  }

  /// Add a [SaveScanResultsException] to the state machine.
  void setSaveScanResultsError() => _setError(SaveScanResultsException());

  /// Add a [StartScanException] to the state machine.
  void setStartScanError() => _setError(StartScanException());

  /// Add a [StopScanException] to the state machine.
  void setStopScanError() => _setError(StopScanException());

  /// Dispose of this state machine.
  void dispose() {
    _controller.close();
  }
}
