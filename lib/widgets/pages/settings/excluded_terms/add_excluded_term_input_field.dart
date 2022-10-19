import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_term_input_field.dart';

/// This widget represents the input field for adding an excluded term.
///
/// It manages a text field that resets itself when it loses focus.
class AddExcludedTermInputField extends StatefulWidget {
  /// The default constructor.
  const AddExcludedTermInputField({
    super.key,
    required this.controller,
    required this.delegate,
    required this.focusNode,
    required this.formKey,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The delegate that manages the list of terms.
  final ExcludedTermsDelegate delegate;

  /// The focus node for the text field.
  final FocusNode focusNode;

  /// The global key that is used to validate the text field.
  final GlobalKey<FormFieldState<String>> formKey;

  @override
  State<AddExcludedTermInputField> createState() =>
      _AddExcludedTermInputFieldState();
}

class _AddExcludedTermInputFieldState extends State<AddExcludedTermInputField> {
  void _handleFocusChange() {
    if (widget.focusNode.hasFocus) {
      return;
    }

    widget.formKey.currentState?.reset();
  }

  void _onEditingComplete() {
    final formState = widget.formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    widget.delegate.addTerm(formState.value!);
    widget.controller.clear();
    formState.reset();
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ExcludedTermInputField.editable(
      controller: widget.controller,
      focusNode: widget.focusNode,
      maxLength: widget.delegate.maxLength,
      onEditingComplete: _onEditingComplete,
      textFieldKey: widget.formKey,
      validator: (value) => widget.delegate.validateTerm(value, translator),
      placeholder: translator.AddDisallowedWord,
    );
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }
}
