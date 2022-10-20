import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
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

    Widget confirmButton;
    Widget cancelButton;
    List<Widget> actions;

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        confirmButton = TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: AppTheme.desctructiveAction.textButtonTheme,
          child: Text(translator.Delete.toUpperCase()),
        );
        cancelButton = TextButton(
          child: Text(translator.Cancel.toUpperCase()),
          onPressed: () => Navigator.of(context).pop(),
        );
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        confirmButton = CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(translator.Delete),
        );
        cancelButton = CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(translator.Cancel),
        );
        break;
    }

    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        actions = [confirmButton, cancelButton];
        break;
      case TextDirection.ltr:
        actions = [cancelButton, confirmButton];
        break;
    }

    return PlatformAwareWidget(
      android: () => AlertDialog(
        title: Text(translator.DeleteDisallowedWord),
        content: Text(
          translator.DeleteDisallowedWordDescription(term),
          maxLines: 3,
        ),
        actions: actions,
      ),
      ios: () => CupertinoAlertDialog(
        title: Text(translator.DeleteDisallowedWord),
        content: Text(
          translator.DeleteDisallowedWordDescription(term),
          maxLines: 3,
        ),
        actions: actions,
      ),
    );
  }
}
