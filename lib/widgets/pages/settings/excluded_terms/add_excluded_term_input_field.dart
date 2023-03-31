import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/excluded_terms_delegate.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_term_input_field.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the input field for adding an excluded term.
///
/// It manages a text field that resets itself when it loses focus.
class AddExcludedTermInputField extends StatelessWidget {
  /// The default constructor.
  const AddExcludedTermInputField({
    required this.controller,
    required this.delegate,
    required this.focusNode,
    required this.formKey,
    super.key,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The delegate that manages the list of terms.
  final ExcludedTermsDelegate delegate;

  /// The focus node for the text field.
  final FocusNode focusNode;

  /// The global key that is used to validate the text field.
  final GlobalKey<FormFieldState<String>> formKey;

  void _onEditingComplete() {
    final formState = formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    delegate.addTerm(formState.value!);

    // After the new excluded term is added,
    // clear the text so a new term can be entered,
    // reset the form state so that the validation error for an empty field is removed
    // (which is caused by clearing the text field).
    // Finally unfocus the text field, as keeping it focused
    // makes it less obvious that a new term can be added.
    controller.clear();
    formState.reset();
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ExcludedTermInputField(
      controller: controller,
      focusNode: focusNode,
      maxLength: delegate.maxLength,
      onEditingComplete: _onEditingComplete,
      suffix: _AddExcludedTermSuffixIcon(
        controller: controller,
        onTap: _onEditingComplete,
        validator: (context, value) => delegate.validateTerm(
          value,
          S.of(context),
        ),
      ),
      textFieldKey: formKey,
      validator: (value) => delegate.validateTerm(value, translator),
      placeholder: translator.addDisallowedWord,
    );
  }
}

class _AddExcludedTermSuffixIcon extends StatelessWidget {
  const _AddExcludedTermSuffixIcon({
    required this.controller,
    required this.onTap,
    required this.validator,
  });

  /// The controller that provides updates about the current text editing value.
  final ValueNotifier<TextEditingValue> controller;

  /// The onTap handler for the suffix button.
  final void Function() onTap;

  /// The validator for the term value.
  final String? Function(BuildContext context, String? value) validator;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (validator(context, controller.value.text) != null) {
          return const SizedBox.shrink();
        }

        return PlatformAwareWidget(
          android: (context) => IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.check),
            onPressed: onTap,
          ),
          ios: (context) => CupertinoIconButton(
            icon: CupertinoIcons.checkmark_alt,
            onPressed: onTap,
          ),
        );
      },
    );
  }
}
