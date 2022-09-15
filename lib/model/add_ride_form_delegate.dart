import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker_delegate.dart';

/// This class represents the delegate for the add ride page.
class AddRideFormDelegate {
  AddRideFormDelegate(this.ref) {
    final repository = ref.read(rideRepositoryProvider);

    _initializeFuture = repository
        .getRideDates()
        .then(_existingRides.addAll)
        .catchError((error) => Future.error(error));
  }

  final WidgetRef ref;

  /// The rides that already exist.
  final _existingRides = <DateTime>{};

  /// The computation that loads the existing rides.
  /// The calendar needs to be able to display these rides.
  Future<void>? _initializeFuture;

  /// A mutex flag that locks the selection while saving.
  bool _savingSelection = false;

  /// The controller that manages the current selection of rides.
  final _selectionController = BehaviorSubject.seeded(<DateTime>{});

  /// The computation that represents saving the selection.
  Future<void>? _submitFuture;

  /// The current date.
  /// This date is used to determine if a ride is before today.
  final DateTime _today = DateTime.now();

  /// The delegate that manages the calendar.
  final calendarDelegate = DatePickerDelegate();

  Set<DateTime> get currentSelection => _selectionController.value;

  Future<void>? get initializeFuture => _initializeFuture;

  Stream<Set<DateTime>> get selection => _selectionController;

  Future<void>? get submitFuture => _submitFuture;

  /// Clear the current selection.
  void clearSelection() {
    if (_selectionController.isClosed) {
      return;
    }

    // The selection is locked while saving.
    if (_savingSelection || currentSelection.isEmpty) {
      return;
    }

    _submitFuture = null;
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

  /// Handle (de)selecting of a day in the calendar.
  void onDaySelected(DateTime date) {
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
    _submitFuture = null;
    _selectionController.add(newSelection);
  }

  /// Save the selected rides.
  void saveSelectedRides() {
    final rides = _selectionController.value;

    if (_savingSelection || rides.isEmpty) {
      return;
    }

    _savingSelection = true;

    final items = rides.map((date) => Ride(date: date)).toList();

    _submitFuture = ref.read(rideRepositoryProvider).addRides(items).then<void>(
      (_) {
        ref.refresh(rideListProvider);
        _savingSelection = false;
      },
    ).catchError((error) {
      _savingSelection = false;

      return Future.error(error);
    });
  }

  /// Dispose of this delegate.
  void dispose() {
    calendarDelegate.dispose();
    _selectionController.close();
  }
}
