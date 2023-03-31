import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';

/// This widget represents a dialog that shows a confirmation for a delete action.
class DeleteItemDialog extends StatelessWidget {
  const DeleteItemDialog({
    super.key,
    required this.description,
    required this.errorDescription,
    required this.future,
    required this.onDeletePressed,
    required this.pendingDescription,
    required this.title,
  });

  /// The description for the confirmation dialog.
  final String description;

  /// The description for the error message
  /// that is displayed when the action failed.
  final String errorDescription;

  /// The future that represents the delete action.
  final Future<void>? future;

  /// The function that executes the delete action.
  final void Function() onDeletePressed;

  /// The description that is shown when the delete is in progress.
  final String pendingDescription;

  /// The title for the dialog.
  final String title;

  @override
  Widget build(BuildContext context) {
    return WeforzaAsyncActionDialog<void>(
      confirmButtonLabel: S.of(context).Delete,
      description: description,
      errorDescription: errorDescription,
      future: future,
      isDestructive: true,
      onConfirmPressed: onDeletePressed,
      pendingDescription: pendingDescription,
      title: title,
    );
  }
}
