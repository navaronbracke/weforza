import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_term_input_field.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the input field for adding an excluded term.
///
/// It manages a text field that resets itself when it loses focus.
class AddExcludedTermInputField extends StatelessWidget {
  /// The default constructor.
  const AddExcludedTermInputField({
    super.key,
    required this.controller,
    required this.delegate,
    required this.focusNode,
    required this.formKey,
    required this.onTap,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The delegate that manages the list of terms.
  final ExcludedTermsDelegate delegate;

  /// The focus node for the text field.
  final FocusNode focusNode;

  /// The global key that is used to validate the text field.
  final GlobalKey<FormFieldState<String>> formKey;

  /// The onTap handler for the text field.
  final void Function() onTap;

  void _onEditingComplete() {
    final formState = formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    delegate.addTerm(formState.value!);
    controller.clear();
    formState.reset();
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ExcludedTermInputField.editable(
      controller: controller,
      focusNode: focusNode,
      maxLength: delegate.maxLength,
      onEditingComplete: _onEditingComplete,
      onTap: onTap,
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
      placeholder: translator.AddDisallowedWord,
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
          android: () => IconButton(
            color: Colors.blue,
            icon: const Icon(Icons.check),
            onPressed: onTap,
          ),
          ios: () => CupertinoIconButton(
            color: CupertinoColors.activeBlue,
            icon: CupertinoIcons.checkmark_alt,
            onPressed: onTap,
          ),
        );
      },
    );
  }
}
