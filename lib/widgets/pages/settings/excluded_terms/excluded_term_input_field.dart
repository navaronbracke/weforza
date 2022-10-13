import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the input field for adding or editing an excluded term.
class ExcludedTermInputField extends StatelessWidget {
  const ExcludedTermInputField({
    super.key,
    required this.delegate,
    this.index,
  });

  /// The delegate that manages the excluded terms.
  final ExcludedTermsDelegate delegate;

  /// The index of the term that should be edited.
  ///
  /// If this is null,
  /// a new term will be created when the text field is submitted.
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: _ExcludedTermInputField(delegate: delegate, index: index),
    );
  }
}

class _ExcludedTermInputField extends StatefulWidget {
  const _ExcludedTermInputField({
    required this.delegate,
    this.index,
  });

  final ExcludedTermsDelegate delegate;

  final int? index;

  @override
  State<_ExcludedTermInputField> createState() =>
      _ExcludedTermInputFieldState();
}

class _ExcludedTermInputFieldState extends State<_ExcludedTermInputField> {
  final focusNode = FocusNode();

  /// Build the invisible counter. The max length is enforced by the text field.
  Widget _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    return const SizedBox.shrink();
  }

  void _handleFocusChange() {
    if (!focusNode.hasFocus) {
      final formState = Form.of(context);

      if (formState == null) {
        return;
      }

      if (widget.index == null) {
        formState.reset(); // Reset back to empty
      } else {
        // Submit the edit, if it is valid.
        if (formState.validate()) {
          formState.save();
        }

        formState.reset();
      }
    }
  }

  void _onEditingComplete(BuildContext context) {
    final formState = Form.of(context);

    if (formState == null || !formState.validate()) {
      return;
    }

    formState.save();
    formState.reset();
  }

  /// Save the form, which either adds a new term or edits an existing term,
  /// depending on the initial state.
  void _onSaved(String? value) {
    if (value == null) {
      return;
    }

    final index = widget.index;

    if (index == null) {
      widget.delegate.addTerm(value);
    } else {
      widget.delegate.editTerm(value, index);
    }
  }

  void _showDeleteTermDialog(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        break; // TODO: show material dialog
      case TargetPlatform.iOS:
        break; // TODO: show cupertino dialog
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);
    final index = widget.index;

    BoxDecoration? decoration;
    String? initialValue;
    String? placeholder;
    Widget? suffixIcon;

    if (index == null) {
      placeholder = translator.AddDisallowedWord;
    } else {
      decoration = const BoxDecoration();
      initialValue = widget.delegate.terms[index];
      suffixIcon = AnimatedBuilder(
        animation: focusNode,
        builder: (context, child) {
          if (focusNode.hasFocus) {
            final style = AppTheme.desctructiveAction.androidDefaultErrorStyle;

            return IconButton(
              icon: Icon(Icons.delete, color: style.color),
              onPressed: () => _showDeleteTermDialog(context),
              padding: EdgeInsets.zero,
            );
          }

          return const SizedBox.shrink();
        },
      );
    }

    return PlatformAwareWidget(
      android: () => TextFormField(
        buildCounter: _buildCounter,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: placeholder,
          suffixIcon: suffixIcon,
        ),
        focusNode: focusNode,
        initialValue: initialValue,
        keyboardType: TextInputType.text,
        onEditingComplete: () => _onEditingComplete(context),
        onSaved: _onSaved,
        maxLength: widget.delegate.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        validator: (value) => widget.delegate.validateTerm(
          value,
          translator,
          originalValue: initialValue,
        ),
      ),
      ios: () {
        Widget child = CupertinoTextFormFieldRow(
          decoration: decoration,
          focusNode: focusNode,
          initialValue: initialValue,
          keyboardType: TextInputType.text,
          maxLength: widget.delegate.maxLength,
          maxLines: 1,
          onEditingComplete: () => _onEditingComplete(context),
          onSaved: _onSaved,
          // The excluded terms have a 15 margin on their border.
          padding: const EdgeInsetsDirectional.fromSTEB(15, 6, 6, 6),
          placeholder: placeholder,
          textInputAction: TextInputAction.done,
          validator: (value) => widget.delegate.validateTerm(
            value,
            translator,
            originalValue: initialValue,
          ),
        );

        if (index != null) {
          child = Row(
            children: [
              Expanded(child: child),
              AnimatedBuilder(
                animation: focusNode,
                builder: (context, child) {
                  if (focusNode.hasFocus) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CupertinoIconButton(
                        color: CupertinoColors.systemRed,
                        icon: CupertinoIcons.delete,
                        onPressed: () => _showDeleteTermDialog(context),
                      ),
                    );
                  }

                  // Reserve the vertical space for the delete button.
                  return const SizedBox(
                    height: kMinInteractiveDimensionCupertino,
                  );
                },
              ),
            ],
          );
        }

        return child;
      },
    );
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    super.dispose();
  }
}
