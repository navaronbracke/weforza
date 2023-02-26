import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/excluded_terms_delegate.dart';
import 'package:weforza/widgets/dialogs/delete_excluded_term_dialog.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/edit_excluded_term_input_field_button_bar.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_term_input_field.dart';

/// This widget represents the input field for editing an existing excluded term.
class EditExcludedTermInputField extends StatefulWidget {
  EditExcludedTermInputField({
    required this.delegate,
    required this.index,
    required this.excludedTerm,
    required this.scrollController,
  }) : super(key: ValueKey(excludedTerm.term));

  /// The delegate that manages the excluded terms.
  final ExcludedTermsDelegate delegate;

  /// The index of [excludedTerm] in the list of terms.
  final int index;

  /// The term that this widget represents.
  final ExcludedTerm excludedTerm;

  /// The scroll controller that manages the enclosing scroll view.
  final ScrollController scrollController;

  @override
  State<EditExcludedTermInputField> createState() => _EditExcludedTermInputFieldState();
}

class _EditExcludedTermInputFieldState extends State<EditExcludedTermInputField> {
  // This flag is used to keep the edit menu open when the delete dialog is shown.
  bool deleteDialogVisible = false;

  final focusNode = FocusNode();

  final GlobalKey<FormFieldState<String>> textFieldKey = GlobalKey();

  /// Request that this widget is made fully visible in the scroll view.
  void _ensureVisible() {
    if (!mounted || !widget.scrollController.hasClients) {
      return;
    }

    final RenderObject? renderObject = context.findRenderObject();

    if (renderObject != null) {
      widget.scrollController.position.ensureVisible(
        renderObject,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void _handleFocusChange() {
    if (!mounted) {
      return;
    }

    // If the focus node lost focus and the delete dialog is not shown,
    // undo the pending edit.
    if (!deleteDialogVisible && !focusNode.hasFocus) {
      _onUndoPressed();
    }

    // Update the button bar visibility.
    setState(() {});

    // If the edit excluded term widget gained focus, it will display its button bar.
    // Request that the bottom of the entire widget's RenderObject is shown on screen.
    if (focusNode.hasFocus) {
      _ensureVisible();
    }
  }

  void _onCommitValidTerm(String value, BuildContext context) {
    if (value != widget.excludedTerm.term) {
      widget.delegate.editTerm(value, widget.index);
    }

    FocusScope.of(context).unfocus();
  }

  void _onDeletePressed(BuildContext context) async {
    deleteDialogVisible = true;

    final result = await showWeforzaDialog<bool>(
      context,
      builder: (_) => DeleteExcludedTermDialog(term: widget.excludedTerm.term),
    );

    if (!mounted) {
      return;
    }

    deleteDialogVisible = false;

    if (result ?? false) {
      widget.delegate.deleteTerm(widget.excludedTerm);

      // When the delete dialog's modal route closes, the wrong widget gets focus.
      // Usually its the add term focus node which greedily grabs focus.
      // Instead of giving focus to a text field, return it back to the navigator,
      // like when the settings page is first opened.
      //
      // Be aware that using the focus manager directly is very rare.
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    }
  }

  void _onEditingComplete(BuildContext context) {
    final formState = textFieldKey.currentState;

    if (formState == null) {
      return;
    }

    final currentValue = formState.value;

    if (currentValue == null || currentValue == widget.excludedTerm.term) {
      FocusScope.of(context).unfocus();
      return;
    }

    if (!formState.validate()) {
      return;
    }

    widget.delegate.editTerm(currentValue, widget.index);
    formState.reset();
    FocusScope.of(context).unfocus();
  }

  void _onUndoPressed() {
    // Reset the text editing value back to the original,
    // and keep the cursor at the end of the text.
    widget.excludedTerm.controller.value = TextEditingValue(
      text: widget.excludedTerm.term,
      selection: TextSelection.collapsed(
        offset: widget.excludedTerm.term.length,
      ),
    );
  }

  String? _validateTerm(BuildContext context, String? value) {
    return widget.delegate.validateTerm(
      value,
      S.of(context),
      originalValue: widget.excludedTerm.term,
    );
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    final textFieldWidget = ExcludedTermInputField(
      controller: widget.excludedTerm.controller,
      focusNode: focusNode,
      maxLength: widget.delegate.maxLength,
      onEditingComplete: () => _onEditingComplete(context),
      textFieldKey: textFieldKey,
      validator: (value) => _validateTerm(context, value),
    );

    // If the delete dialog is visible, the edit menu should not be closed.
    if (deleteDialogVisible || focusNode.hasFocus) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Consume gestures so that they are not handled by the focus absorber.
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            textFieldWidget,
            EditExcludedTermInputFieldButtonBar(
              controller: widget.excludedTerm.controller,
              onCommitValidTerm: (value) => _onCommitValidTerm(value, context),
              onDeletePressed: _onDeletePressed,
              onUndoPressed: _onUndoPressed,
              term: widget.excludedTerm.term,
              validator: _validateTerm,
            ),
          ],
        ),
      );
    }

    return textFieldWidget;
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    super.dispose();
  }
}
