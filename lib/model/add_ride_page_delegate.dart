import 'package:rxdart/rxdart.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker_delegate.dart';

/// This class represents the delegate for the add ride page.
class AddRidePageDelegate extends AsyncComputationDelegate<void> {
  AddRidePageDelegate({
    required this.repository,
  }) {
    _initializeFuture = repository.getRideDates().then(_existingRides.addAll);
  }

  /// The delegate that manages the calendar.
  final calendarDelegate = DatePickerDelegate();

  /// The repository that manages the rides.
  final RideRepository repository;

  /// The rides that already exist.
  final _existingRides = <DateTime>{};

  /// The computation that loads the existing rides for the ride calendar.
  Future<void>? _initializeFuture;

  /// A mutex flag that locks the selection while saving.
  bool _savingSelection = false;

  /// The controller that manages the current selection of rides.
  final _selectionController = BehaviorSubject.seeded(<DateTime>{});

  /// The date of today.
  /// This date is used to determine if a ride is before today.
  final _today = DateTime.now();

  /// Get the current selection.
  Set<DateTime> get currentSelection => _selectionController.value;

  /// Get the initialization computation.
  Future<void>? get initializeFuture => _initializeFuture;

  /// Get the [Stream] of selection changes.
  Stream<Set<DateTime>> get selectionStream => _selectionController;

  /// Clear the current selection.
  void clearSelection() {
    if (_selectionController.isClosed) {
      return;
    }

    // The selection is locked while saving.
    if (_savingSelection || currentSelection.isEmpty) {
      return;
    }

    // Clear any submit errors from the last attempt.
    reset();
    _selectionController.add(const {});
  }

  /// Whether [date] is before today.
  bool isBeforeToday(DateTime date) {
    return date.isBefore(DateTime(_today.year, _today.month, _today.day));
  }

  /// Whether the given date has a ride scheduled.
  /// If [inCurrentSession] is true,
  /// this method also checks if the ride was scheduled in the current session.
  bool isScheduled(DateTime date, {bool inCurrentSession = false}) {
    if (inCurrentSession) {
      return !_existingRides.contains(date) && currentSelection.contains(date);
    }

    return _existingRides.contains(date) || currentSelection.contains(date);
  }

  /// Save the selected rides.
  ///
  /// The [whenComplete] handler is invoked after the rides have been added.
  void saveRides({
    required void Function() whenComplete,
  }) async {
    final rides = _selectionController.value;

    if (!canStartComputation() || _savingSelection || rides.isEmpty) {
      return;
    }

    _savingSelection = true;

    try {
      await repository.addRides(rides.map((date) => Ride(date: date)).toList());

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
    // The selection is locked while saving.
    // Abort if the ride was scheduled in another session.
    if (_savingSelection || _existingRides.contains(date)) {
      return;
    }

    final newSelection = Set.of(currentSelection);

    if (newSelection.contains(date)) {
      newSelection.remove(date);
    } else {
      newSelection.add(date);
    }

    // Clear any submit errors from the last attempt.
    reset();
    _selectionController.add(newSelection);
  }

  @override
  void dispose() {
    calendarDelegate.dispose();
    _selectionController.close();
    super.dispose();
  }
}
