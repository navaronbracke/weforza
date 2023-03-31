import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MaxLengthEnforcement;

import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the base input field for an excluded term.
class ExcludedTermInputField extends StatelessWidget {
  /// The constructor for an editable text field.
  const ExcludedTermInputField.editable({
    super.key,
    required TextEditingController this.controller,
    required FocusNode this.focusNode,
    required int this.maxLength,
    required void Function() this.onEditingComplete,
    this.onTap,
    this.placeholder,
    this.suffix,
    required GlobalKey<FormFieldState<String>> this.textFieldKey,
    required String? Function(String? value) this.validator,
  })  : initialValue = null,
        readOnly = false;

  /// The constructor for a read-only text field.
  const ExcludedTermInputField.readOnly({
    super.key,
    required String this.initialValue,
    required void Function() this.onTap,
  })  : controller = null,
        focusNode = null,
        onEditingComplete = null,
        maxLength = null,
        placeholder = null,
        readOnly = true,
        suffix = null,
        textFieldKey = null,
        validator = null;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// The initial value for the text field.
  final String? initialValue;

  /// The max length for the text field.
  final int? maxLength;

  /// The function that is called when editing is finalized.
  final void Function()? onEditingComplete;

  /// The function that is called when the text field is tapped.
  final void Function()? onTap;

  /// The placeholder text for the text field when it is empty.
  final String? placeholder;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// The suffix for the text field.
  final Widget? suffix;

  /// The global key that is used to validate the text field.
  final GlobalKey<FormFieldState<String>>? textFieldKey;

  /// The validator function for the text field.
  final String? Function(String? value)? validator;

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
        initialValue: initialValue,
        keyboardType: TextInputType.text,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: 1,
        onEditingComplete: onEditingComplete,
        onTap: onTap,
        readOnly: readOnly,
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
          initialValue: initialValue,
          keyboardType: TextInputType.text,
          maxLength: maxLength,
          maxLines: 1,
          onEditingComplete: onEditingComplete,
          onTap: onTap,
          // The excluded terms have a 15 margin on their border.
          padding: const EdgeInsetsDirectional.fromSTEB(15, 6, 6, 6),
          placeholder: placeholder,
          readOnly: readOnly,
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
