import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/model/selected_excluded_term.dart';
import 'package:weforza/model/selected_excluded_term_delegate.dart';
import 'package:weforza/widgets/custom/dialogs/delete_excluded_term_dialog.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_term_input_field.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the input field for editing an existing excluded term.
///
/// It manages a text field that resets itself to its initial value when it loses focus.
/// The input field will show an edit menu centered below the text field.
/// This edit menu contains buttons for undoing the pending edit,
/// committing the pending edit and deleting the term.
class EditExcludedTermInputField extends StatefulWidget {
  const EditExcludedTermInputField({
    super.key,
    required this.delegate,
    required this.index,
    required this.onSelected,
    required this.selectionDelegate,
    required this.term,
    required this.textFormFieldKey,
  });

  /// The delegate that manages the excluded terms.
  final ExcludedTermsDelegate delegate;

  /// The index of [term].
  final int index;

  /// The function that handles the selection of a term.
  final void Function(String term) onSelected;

  /// The delegate that manages the selected excluded term.
  final SelectedExcludedTermDelegate selectionDelegate;

  /// The term to edit.
  final String term;

  /// The key for the selected term text field.
  ///
  /// This key is used to validate the currently selected term.
  final GlobalKey<FormFieldState<String>> textFormFieldKey;

  @override
  State<EditExcludedTermInputField> createState() =>
      _EditExcludedTermInputFieldState();
}

class _EditExcludedTermInputFieldState
    extends State<EditExcludedTermInputField> {
  void _onConfirmPressed(TextEditingValue textEditingValue) {
    if (textEditingValue.text == widget.term) {
      widget.selectionDelegate.clearSelection();

      return;
    }

    final formState = widget.textFormFieldKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    widget.delegate.editTerm(formState.value!, widget.index);
    widget.selectionDelegate.clearSelection();
  }

  void _onDeletePressed(BuildContext context) async {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => DeleteExcludedTermDialog(term: widget.term),
        );

        if (result ?? false) {
          widget.delegate.deleteTerm(widget.term);
        }

        break;
      case TargetPlatform.iOS:
        final result = await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => DeleteExcludedTermDialog(term: widget.term),
        );

        if (result ?? false) {
          widget.delegate.deleteTerm(widget.term);
        }

        break;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  void _onEditingComplete() {
    final formState = widget.textFormFieldKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    widget.delegate.editTerm(formState.value!, widget.index);
    formState.reset();
  }

  String? _validateTerm(BuildContext context, String? value) {
    return widget.delegate.validateTerm(
      value,
      S.of(context),
      originalValue: widget.term,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectedExcludedTerm?>(
      initialData: widget.selectionDelegate.selectedTerm,
      stream: widget.selectionDelegate.stream,
      builder: (context, snapshot) {
        final selectedValue = snapshot.data;

        if (selectedValue != null && selectedValue.value == widget.term) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludedTermInputField.editable(
                controller: selectedValue.controller,
                focusNode: selectedValue.focusNode,
                maxLength: widget.delegate.maxLength,
                onEditingComplete: _onEditingComplete,
                textFieldKey: widget.textFormFieldKey,
                validator: (value) => _validateTerm(context, value),
              ),
              _EditExcludedTermInputFieldButtonBar(
                controller: selectedValue.controller,
                onConfirmPressed: _onConfirmPressed,
                onDeletePressed: _onDeletePressed,
                onUndoPressed: widget.selectionDelegate.undoPendingEdit,
                term: widget.term,
                validator: _validateTerm,
              ),
            ],
          );
        }

        return ExcludedTermInputField.readOnly(
          initialValue: widget.term,
          onTap: () => widget.onSelected(widget.term),
        );
      },
    );
  }
}

/// This widget represents the button bar for a [EditExcludedTermInputField].
///
/// It provides a button to delete the original term,
/// a confirm button to commit the pending edit,
/// and an undo button to revert the pending edit.
class _EditExcludedTermInputFieldButtonBar extends StatelessWidget {
  const _EditExcludedTermInputFieldButtonBar({
    required this.controller,
    required this.onConfirmPressed,
    required this.onDeletePressed,
    required this.onUndoPressed,
    required this.term,
    required this.validator,
  });

  /// The controller that provides updates about the current text editing value.
  final ValueNotifier<TextEditingValue> controller;

  /// The onTap handler for the confirm button.
  final void Function(TextEditingValue textEditingValue) onConfirmPressed;

  /// The onTap handler for the delete button.
  final void Function(BuildContext context) onDeletePressed;

  /// The onTap handler for the undo button.
  final void Function() onUndoPressed;

  /// The current value of the term.
  final String term;

  /// The validator for the term value.
  final String? Function(BuildContext context, String? value) validator;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      // The delete button is always shown.
      child: PlatformAwareWidget(
        android: () {
          return IconButton(
            icon: Icon(
              Icons.delete,
              color: AppTheme.desctructiveAction.androidDefaultErrorStyle.color,
            ),
            onPressed: () => onDeletePressed(context),
            padding: EdgeInsets.zero,
          );
        },
        ios: () => CupertinoIconButton(
          color: CupertinoColors.systemRed,
          icon: CupertinoIcons.delete,
          onPressed: () => onDeletePressed(context),
        ),
      ),
      builder: (context, child) {
        final currentValue = controller.value;

        final isValid = validator(context, currentValue.text) == null;

        final confirmButton = PlatformAwareWidget(
          android: () => IconButton(
            color: Colors.blue,
            icon: const Icon(Icons.check),
            onPressed: isValid ? () => onConfirmPressed(currentValue) : null,
          ),
          ios: () => CupertinoIconButton(
            color: CupertinoColors.activeBlue,
            icon: CupertinoIcons.checkmark_alt,
            onPressed: isValid ? () => onConfirmPressed(currentValue) : null,
          ),
        );

        // The undo button is disabled if the value is the same.
        final undoButton = PlatformAwareWidget(
          android: () => IconButton(
            color: Colors.black,
            icon: const Icon(Icons.undo),
            onPressed: currentValue.text == term ? null : onUndoPressed,
          ),
          ios: () => CupertinoIconButton(
            color: CupertinoColors.black,
            icon: CupertinoIcons.arrow_counterclockwise,
            onPressed: currentValue.text == term ? null : onUndoPressed,
          ),
        );

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            undoButton,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: confirmButton,
            ),
            child!,
          ],
        );
      },
    );
  }
}
