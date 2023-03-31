import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the dialog
/// for confirming the deletion of an excluded term.
class DeleteExcludedTermDialog extends StatelessWidget {
  const DeleteExcludedTermDialog({super.key, required this.term});

  /// The term that should be deleted.
  final String term;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    const splitDelimiter = '|term|';

    // The translated value has one delimiter,
    // which is used to split off the value for the term.
    // That value is put in bold text, while the rest is not.
    final description = translator.DeleteDisallowedWordDescription.split(
      splitDelimiter,
    );

    assert(
      description.length == 2,
      'The description requires at most one delimiter.',
    );

    return WeforzaAlertDialog(
      confirmButtonBuilder: (context, platform) {
        switch (platform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            return TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: AppTheme.desctructiveAction.textButtonTheme,
              child: Text(translator.Delete),
            );
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(translator.Delete),
            );
        }
      },
      cancelButtonBuilder: WeforzaAlertDialog.defaultCancelButton,
      description: Text.rich(
        TextSpan(
          text: description.first,
          children: [
            TextSpan(
              text: term,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: description.last),
          ],
        ),
      ),
      title: translator.DeleteDisallowedWord,
    );
  }
}
