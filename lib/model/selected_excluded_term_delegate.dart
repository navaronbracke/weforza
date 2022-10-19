import 'package:rxdart/subjects.dart';
import 'package:weforza/model/selected_excluded_term.dart';

/// This class represents a delegate that manages
/// the currently selected excluded term.
class SelectedExcludedTermDelegate {
  final _controller = BehaviorSubject<SelectedExcludedTerm?>();

  /// Get the currently selected term.
  SelectedExcludedTerm? get selectedTerm => _controller.valueOrNull;

  /// Get the stream of changes to the currently selected term.
  Stream<SelectedExcludedTerm?> get stream => _controller;

  /// Clear the current selection.
  void clearSelection() {
    final previous = _controller.valueOrNull;

    _controller.add(null);
    previous?.dispose(); // Clean up the old selection value.
  }

  /// Set the selected term.
  void setSelectdTerm(String value) {
    final previousValue = selectedTerm;

    // If the same value is selected,
    // the controller and focus node should be preserved.
    if (value == previousValue?.value) {
      return;
    }

    // Update the selection first,
    // this disconnects the controller and focus node
    // from the previous text field,
    // and attaches a new controller and focus node to the field of the new value.
    _controller.add(SelectedExcludedTerm(value));

    // Dispose the now orphaned controller and focus node from the previous term.
    previousValue?.dispose();
  }

  /// Dispose of this delegate.
  void dispose() {
    _controller.valueOrNull?.dispose();
    _controller.close();
  }
}
