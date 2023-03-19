import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MaxLengthEnforcement;

import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the base input field for an excluded term.
class ExcludedTermInputField extends StatelessWidget {
  const ExcludedTermInputField({
    required this.controller,
    required this.focusNode,
    required this.maxLength,
    required this.onEditingComplete,
    required this.validator,
    this.contextMenuButtonBar,
    this.decoration,
    this.placeholder,
    this.suffix,
    this.textFieldKey,
    super.key,
  });

  /// The widget that acts as the context menu button bar below the text field.
  final Widget? contextMenuButtonBar;

  /// The controller for the text field.
  final TextEditingController controller;

  /// The decoration to apply to the text field and the context menu.
  final BoxDecoration? decoration;

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
  Widget? _buildAndroidCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    return null;
  }

  Widget _buildTextField() {
    return PlatformAwareWidget(
      android: (_) => TextFormField(
        key: textFieldKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        buildCounter: _buildAndroidCounter,
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

  Widget _wrapWithDecoration(Widget child, {BoxDecoration? decoration}) {
    if (decoration == null) {
      return child;
    }

    return DecoratedBox(decoration: decoration, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final Widget textField = _buildTextField();
    final Widget? contextMenu = contextMenuButtonBar;

    if (contextMenu == null) {
      return _wrapWithDecoration(textField, decoration: decoration);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Consume gestures so that they are not handled by the focus absorber.
        // Otherwise the context menu would be closed when tapping on its blank areas.
      },
      child: _wrapWithDecoration(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[textField, contextMenu],
        ),
        decoration: decoration,
      ),
    );
  }
}
