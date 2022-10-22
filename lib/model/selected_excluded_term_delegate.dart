import 'package:flutter/widgets.dart' show TextSelection, TextEditingValue;
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

    if (previous == null) {
      return;
    }

    _controller.add(null);
    previous.dispose(); // Clean up the old selection value.
  }

  /// Set the selected term.
  void setSelectedTerm(String value) {
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

    // Request focus for the new selection,
    // and move the cursor to the end of the text.
    _controller.valueOrNull?.focusNode.requestFocus();
    _controller.valueOrNull?.controller.selection = TextSelection.collapsed(
      offset: value.length,
    );

    // Dispose the now orphaned controller and focus node from the previous term.
    previousValue?.dispose();
  }

  /// Undo the pending edit, but preserve the selected item.
  void undoPendingEdit() {
    final previousValue = selectedTerm;

    if (previousValue == null) {
      return;
    }

    // Reset the text editing value back to the original,
    // and keep the cursor at the end of the text.
    previousValue.controller.value = TextEditingValue(
      text: previousValue.value,
      selection: TextSelection.collapsed(offset: previousValue.value.length),
    );
  }

  /// Dispose of this delegate.
  void dispose() {
    _controller.valueOrNull?.dispose();
    _controller.close();
  }
}
