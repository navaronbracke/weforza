/// @docImport 'package:weforza/widgets/pages/settings/excluded_terms/edit_excluded_term_input_field.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the button bar for an [EditExcludedTermInputField].
///
/// It provides a button to delete the original term,
/// a confirm button to commit the pending edit,
/// and an undo button to revert the pending edit.
class EditExcludedTermInputFieldButtonBar extends StatelessWidget {
  const EditExcludedTermInputFieldButtonBar({
    required this.controller,
    required this.onCommitValidTerm,
    required this.onDeletePressed,
    required this.onUndoPressed,
    required this.term,
    required this.validator,
    super.key,
  });

  /// The controller that provides updates about the current text editing value.
  final ValueNotifier<TextEditingValue> controller;

  /// The function that is called when a valid term is committed.
  final void Function(String value) onCommitValidTerm;

  /// The onTap handler for the delete button.
  final void Function(BuildContext context) onDeletePressed;

  /// The onTap handler for the undo button.
  final void Function() onUndoPressed;

  /// The current value of the term.
  ///
  /// This value is contextually different from the value in the [controller],
  /// as the latter is the pending value that has not yet been committed.
  final String term;

  /// The validator for the term value.
  final String? Function(BuildContext context, String? value) validator;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      // The delete button is always shown.
      child: PlatformAwareWidget(
        android: (context) {
          return IconButton(
            icon: Icon(Icons.delete, color: ColorScheme.of(context).error),
            onPressed: () => onDeletePressed(context),
            padding: EdgeInsets.zero,
          );
        },
        ios: (context) {
          return CupertinoIconButton(
            color: CupertinoColors.systemRed,
            icon: CupertinoIcons.delete,
            onPressed: () => onDeletePressed(context),
          );
        },
      ),
      builder: (context, child) {
        final currentValue = controller.value.text;

        final isValid = validator(context, currentValue) == null;

        final confirmButton = PlatformAwareWidget(
          android: (context) {
            return IconButton(
              color: ColorScheme.of(context).primary,
              icon: const Icon(Icons.check),
              onPressed: isValid ? () => onCommitValidTerm(currentValue) : null,
            );
          },
          ios: (context) {
            return CupertinoIconButton(
              icon: CupertinoIcons.checkmark_alt,
              onPressed: isValid ? () => onCommitValidTerm(currentValue) : null,
            );
          },
        );

        // The undo button is disabled if the value is the same.
        final undoButton = PlatformAwareWidget(
          android: (context) {
            Color color;

            switch (Theme.of(context).brightness) {
              case Brightness.dark:
                color = Colors.white;
                break;
              case Brightness.light:
                color = Colors.black;
                break;
            }

            return IconButton(
              color: color,
              icon: const Icon(Icons.undo),
              onPressed: currentValue == term ? null : onUndoPressed,
            );
          },
          ios: (context) {
            final color = const CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.black,
              darkColor: CupertinoColors.white,
            ).resolveFrom(context);

            return CupertinoIconButton(
              color: color,
              icon: CupertinoIcons.arrow_counterclockwise,
              onPressed: currentValue == term ? null : onUndoPressed,
            );
          },
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            undoButton,
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: confirmButton),
            child!,
          ],
        );
      },
    );
  }
}
