import 'dart:async';

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
    this.decoration,
    this.divider,
  }) : super(key: ValueKey(excludedTerm.term));

  /// The decoration for the text field and the context menu.
  final BoxDecoration? decoration;

  /// The delegate that manages the excluded terms.
  final ExcludedTermsDelegate delegate;

  /// The divider that is placed above the text field.
  ///
  /// This widget is typically used to add separators
  /// between this widget and the previous one in a list of [ExcludedTermInputField]s.
  final Widget? divider;

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

  /// The cached viewInsets from the MediaQueryData.
  ///
  /// This value is cached to prevent lookup of the MediaQueryData when this widget is disposed.
  EdgeInsets _viewInsets = EdgeInsets.zero;

  /// This completer is used to notify [_onDeletePressed] when the view insets
  Completer<void>? _viewInsetsHiddenCompleter;

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

    if (focusNode.hasFocus) {
      // Just give up focus, there is no on-screen keyboard.
      if (_viewInsets.bottom == 0) {
        focusNode.unfocus();
      } else {
        // The text field has focus and a keyboard is visible on screen.
        // First, set up a completer that will complete when the bottom view insets are zero.
        // Then, unfocus the text field to make the keyboard dissapear.
        _viewInsetsHiddenCompleter = Completer<void>();
        focusNode.unfocus();

        // Finally, await the keyboard dissapearing completely.
        await _viewInsetsHiddenCompleter?.future;
      }
    }

    if (!mounted) {
      return;
    }

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewInsets = MediaQuery.viewInsetsOf(context);

    // If the bottom view insets collapsed back to zero, notify the waiting view insets completer.
    if (_viewInsetsHiddenCompleter == null || _viewInsetsHiddenCompleter!.isCompleted) {
      return;
    }

    if (_viewInsets.bottom == 0.0) {
      _viewInsetsHiddenCompleter?.complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget contextMenuButtonBar = EditExcludedTermInputFieldButtonBar(
      controller: widget.excludedTerm.controller,
      onCommitValidTerm: (value) => _onCommitValidTerm(value, context),
      onDeletePressed: _onDeletePressed,
      onUndoPressed: _onUndoPressed,
      term: widget.excludedTerm.term,
      validator: _validateTerm,
    );

    return ExcludedTermInputField(
      // The context menu is shown when the text field has focus,
      // or if the delete dialog is visible after pressing the delete button.
      // When pressing the delete button focus moves to the delete dialog.
      contextMenuButtonBar: deleteDialogVisible || focusNode.hasFocus ? contextMenuButtonBar : null,
      controller: widget.excludedTerm.controller,
      decoration: widget.decoration,
      divider: widget.divider,
      focusNode: focusNode,
      maxLength: widget.delegate.maxLength,
      onEditingComplete: () => _onEditingComplete(context),
      textFieldKey: textFieldKey,
      validator: (value) => _validateTerm(context, value),
    );
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    super.dispose();
  }
}
