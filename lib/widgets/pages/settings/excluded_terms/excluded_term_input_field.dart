import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MaxLengthEnforcement;

import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the base input field for an excluded term.
class ExcludedTermInputField extends StatelessWidget {
  const ExcludedTermInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.maxLength,
    required this.onEditingComplete,
    this.placeholder,
    this.suffix,
    this.textFieldKey,
    required this.validator,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The focus node for the text field.
  final FocusNode focusNode;

  /// The max length for the text field.
  final int maxLength;

  /// The function that is called when editing is finalized.
  final void Function() onEditingComplete;

  /// The placeholder text for the text field when it is empty.
  final String? placeholder;

  /// The suffix for the text field.
  final Widget? suffix;

  /// The key for the underlying text field.
  final GlobalKey<FormFieldState<String>>? textFieldKey;

  /// The validator function for the text field.
  final String? Function(String? value) validator;

  /// Build the invisible counter. The max length is enforced by the text field.
  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (_) => TextFormField(
        key: textFieldKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        buildCounter: _buildCounter,
        controller: controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: placeholder,
          isDense: true,
          suffixIcon: suffix,
        ),
        focusNode: focusNode,
        keyboardType: TextInputType.text,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: 1,
        onEditingComplete: onEditingComplete,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        validator: validator,
      ),
      ios: (_) {
        final child = CupertinoTextFormFieldRow(
          key: textFieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          decoration: const BoxDecoration(),
          focusNode: focusNode,
          keyboardType: TextInputType.text,
          maxLength: maxLength,
          maxLines: 1,
          onEditingComplete: onEditingComplete,
          // The excluded terms have a 15 margin on their border.
          padding: const EdgeInsetsDirectional.fromSTEB(15, 6, 6, 6),
          placeholder: placeholder,
          textInputAction: TextInputAction.done,
          validator: validator,
        );

        if (suffix == null) {
          return child;
        }

        return Row(children: [Expanded(child: child), suffix!]);
      },
    );
  }
}
