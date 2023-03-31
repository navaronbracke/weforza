import 'package:flutter/widgets.dart' show FocusNode, TextEditingController;

/// This class represents a value wrapper for a selected excluded term.
/// It wraps the initial value of the term,
/// the [TextEditingController] and the [FocusNode].
///
/// Equality is based on the [value].
class SelectedExcludedTerm {
  SelectedExcludedTerm(
    this.value,
  ) : controller = TextEditingController(text: value);

  /// The text editing controller for this term.
  final TextEditingController controller;

  /// The focus node of this term.
  final FocusNode focusNode = FocusNode();

  /// The initial value of this term.
  final String value;

  /// Whether this object was disposed.
  bool _isDisposed = false;

  /// Dispose of this object.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    controller.dispose();
    focusNode.dispose();
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is SelectedExcludedTerm && value == other.value;
  }
}
