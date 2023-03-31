import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

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
  /// Build the invisible counter. The max length is enforced by the text field.
  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    return null;
  }

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
    final placeholder = translator.AddDisallowedWord;

    return PlatformAwareWidget(
      android: () => TextFormField(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        buildCounter: _buildCounter,
        controller: widget.controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: placeholder,
          isDense: true,
        ),
        focusNode: widget.focusNode,
        keyboardType: TextInputType.text,
        onEditingComplete: _onEditingComplete,
        maxLength: widget.delegate.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        validator: (value) => widget.delegate.validateTerm(value, translator),
      ),
      ios: () => CupertinoTextFormFieldRow(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.text,
        maxLength: widget.delegate.maxLength,
        maxLines: 1,
        onEditingComplete: _onEditingComplete,
        // The excluded terms have a 15 margin on their border.
        padding: const EdgeInsetsDirectional.fromSTEB(15, 6, 6, 6),
        placeholder: placeholder,
        textInputAction: TextInputAction.done,
        validator: (value) => widget.delegate.validateTerm(value, translator),
      ),
    );
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }
}
