import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker_delegate.dart';

/// This class represents the delegate for the add ride page.
class AddRidePageDelegate extends AsyncComputationDelegate<void> {
  new({required this._repository}) {
    _initializeFuture = _repository.getRideDates().then(_existingRides.addAll);
  }

  /// The delegate that manages the calendar.
  final calendarDelegate = DatePickerDelegate();

  /// The repository that manages the rides.
  final RideRepository _repository;

  /// The rides that already exist.
  final _existingRides = <DateTime>{};

  /// The computation that loads the existing rides for the ride calendar.
  Future<void>? _initializeFuture;

  /// A mutex flag that locks the selection while saving.
  bool _savingSelection = false;

  /// The notifier that manages the current selection of rides.
  final ValueNotifier<Set<DateTime>> _selectionNotifier = ValueNotifier(<DateTime>{});

  /// The date of today.
  /// This date is used to determine if a ride is before today.
  final _today = DateTime.now();

  /// Get the initialization computation.
  Future<void>? get initializeFuture => _initializeFuture;

  /// Get the [ValueListenable] of selection changes.
  ValueListenable<Set<DateTime>> get selectionListenable => _selectionNotifier;

  /// Clear the current selection.
  void clearSelection() {
    if (!mounted) {
      return;
    }

    final currentSelection = _selectionNotifier.value;

    // The selection is locked while saving.
    if (_savingSelection || currentSelection.isEmpty) {
      return;
    }

    // Clear any submit errors from the last attempt.
    reset();
    _selectionNotifier.value = const {};
  }

  /// Whether [date] is before today.
  ///
  /// This method normalizes `today` so that the hour, minute, second, millisecond and microsecond are set to zero.
  bool isBeforeToday(DateTime date) {
    return date.isBefore(DateTime(_today.year, _today.month, _today.day));
  }

  /// Whether the given date has a ride scheduled.
  /// If [inCurrentSession] is true,
  /// this method also checks if the ride was scheduled in the current session.
  bool isScheduled(DateTime date, {bool inCurrentSession = false}) {
    final currentSelection = _selectionNotifier.value;

    if (inCurrentSession) {
      return !_existingRides.contains(date) && currentSelection.contains(date);
    }

    return _existingRides.contains(date) || currentSelection.contains(date);
  }

  /// Save the selected rides.
  ///
  /// The [whenComplete] handler is invoked after the rides have been added.
  void saveRides({required void Function() whenComplete}) async {
    final currentSelection = _selectionNotifier.value;

    if (!canStartComputation() || _savingSelection || currentSelection.isEmpty) {
      return;
    }

    _savingSelection = true;

    try {
      await _repository.addRides(currentSelection);

      setDone(null);
      whenComplete();
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    } finally {
      _savingSelection = false;
    }
  }

  /// Handle (de)selecting of a day in the calendar.
  void selectDay(DateTime date) {
    // TODO: should selecting days in the past be locked behind a toggle?
    // The selection is locked while saving.
    // Abort if the ride was scheduled in another session.
    if (_savingSelection || _existingRides.contains(date)) {
      return;
    }

    final newSelection = Set.of(_selectionNotifier.value);

    if (newSelection.contains(date)) {
      newSelection.remove(date);
    } else {
      newSelection.add(date);
    }

    // Clear any submit errors from the last attempt.
    reset();
    _selectionNotifier.value = newSelection;
  }

  @override
  void dispose() {
    calendarDelegate.dispose();
    _selectionNotifier.dispose();
    super.dispose();
  }
}
