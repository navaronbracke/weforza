import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents an alert dialog
/// that adapts itself to the current platform.
class WeforzaAlertDialog extends StatelessWidget {
  /// The private constructor.
  const new _({
    required this.confirmButtonBuilder,
    required this.description,
    required this.title,
    this.cancelButtonBuilder,
  }) : actionsAlignment = null;

  /// Construct a [WeforzaAlertDialog] that uses a confirm and cancel button.
  factory defaultButtons({
    required String confirmButtonLabel,
    required Widget description,
    required bool isDestructive,
    required void Function() onConfirmPressed,
    required String title,
  }) {
    return WeforzaAlertDialog._(
      cancelButtonBuilder: _buildDefaultCancelButton,
      confirmButtonBuilder: (context, platform) {
        return _buildDefaultConfirmButton(context, isDestructive, confirmButtonLabel, onConfirmPressed, platform);
      },
      description: description,
      title: title,
    );
  }

  /// Construct a [WeforzaAlertDialog] that uses a single button.
  const new singleButton({
    required this.confirmButtonBuilder,
    required this.description,
    required this.title,
    super.key,
    this.actionsAlignment,
  }) : cancelButtonBuilder = null;

  /// The alignment for the dialog actions.
  ///
  /// This is ignored on iOS and MacOS.
  final MainAxisAlignment? actionsAlignment;

  /// The builder for the cancel button.
  final Widget Function(BuildContext, TargetPlatform)? cancelButtonBuilder;

  /// The builder for the confirm button.
  final Widget Function(BuildContext, TargetPlatform) confirmButtonBuilder;

  /// The description for the dialog.
  ///
  /// This is usually a [Text] widget.
  final Widget description;

  /// The title for the dialog.
  final String title;

  /// Build the default cancel button.
  ///
  /// Returns a button with the default `Cancel` label
  /// that closes the dialog when pressed.
  static Widget _buildDefaultCancelButton(BuildContext context, TargetPlatform platform) {
    final label = S.of(context).cancel;

    return switch (platform) {
      .android ||
      .fuchsia ||
      .linux ||
      .windows => TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(label)),
      .iOS || .macOS => CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () => Navigator.of(context).pop(),
        child: Text(label),
      ),
    };
  }

  static Widget _buildDefaultConfirmButton(
    BuildContext context,
    bool isDestructive,
    String label,
    void Function() onPressed,
    TargetPlatform platform,
  ) {
    return switch (platform) {
      .android || .fuchsia || .linux || .windows => TextButton(
        onPressed: onPressed,
        style: isDestructive ? Theme.of(context).extension<DestructiveButtons>()!.textButtonStyle : null,
        child: Text(label),
      ),
      .iOS ||
      .macOS => CupertinoDialogAction(isDestructiveAction: isDestructive, onPressed: onPressed, child: Text(label)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final TargetPlatform platform = defaultTargetPlatform;
    final Widget confirmButton = confirmButtonBuilder(context, platform);
    final Widget? cancelButton = cancelButtonBuilder?.call(context, platform);

    final actions = <Widget>[?cancelButton, confirmButton];

    return switch (platform) {
      .android || .fuchsia || .linux || .windows => AlertDialog(
        actions: actions,
        actionsAlignment: actionsAlignment,
        content: description,
        title: Text(title, softWrap: true),
      ),
      .iOS ||
      .macOS => CupertinoAlertDialog(actions: actions, content: description, title: Text(title, softWrap: true)),
    };
  }
}

/// This widget represents an [WeforzaAlertDialog] for an asynchronous action.
class WeforzaAsyncActionDialog<T> extends StatelessWidget {
  const new({
    required this.confirmButtonLabel,
    required this.description,
    required this.errorDescription,
    required this.future,
    required this.onConfirmPressed,
    required this.pendingDescription,
    required this.title,
    this.isDestructive = false,
    super.key,
  });

  /// The label for the confirm button.
  final String confirmButtonLabel;

  /// The description for the dialog.
  ///
  /// This is usually a [Text] widget.
  final Widget description;

  /// The description that is displayed when [future]
  /// returned an error.
  ///
  /// This is usually a [Text] widget.
  final Widget errorDescription;

  /// The future that represents the underlying asynchronous action.
  final Future<T>? future;

  /// Whether the dialog's confirm action is a destructive action.
  final bool isDestructive;

  /// The onTap handler for the confirm button.
  final void Function() onConfirmPressed;

  /// The description that is used when [future] is computing its result.
  ///
  /// This is usually a [Text] widget.
  final Widget pendingDescription;

  /// The title for the dialog.
  final String title;

  Widget _buildDismissErrorAction(BuildContext context, TargetPlatform platform) {
    final label = S.of(context).ok;

    return switch (platform) {
      .android ||
      .fuchsia ||
      .linux ||
      .windows => TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(label)),
      .iOS || .macOS => CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () => Navigator.of(context).pop(),
        child: Text(label),
      ),
    };
  }

  Widget _buildPendingAction(BuildContext context, TargetPlatform platform) {
    return switch (platform) {
      .android || .fuchsia || .linux || .windows => const Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      .iOS || .macOS => const CupertinoDialogAction(child: CupertinoActivityIndicator()),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        // The pending dialog shoulld not respond to taps,
        // as it is purely informational.
        // It should also not be able to be dismissed by pressing outside of the dialog.
        final pending = GestureDetector(
          behavior: .opaque,
          onTap: () {
            // Consume the onTap gesture.
          },
          child: WeforzaAlertDialog.singleButton(
            actionsAlignment: .center,
            confirmButtonBuilder: _buildPendingAction,
            description: pendingDescription,
            title: title,
          ),
        );

        switch (snapshot.connectionState) {
          case .none:
            return WeforzaAlertDialog.defaultButtons(
              confirmButtonLabel: confirmButtonLabel,
              description: description,
              isDestructive: isDestructive,
              onConfirmPressed: onConfirmPressed,
              title: title,
            );
          case .active:
          case .waiting:
            return pending;
          case .done:
            final error = snapshot.error;

            if (error != null) {
              return WeforzaAlertDialog.singleButton(
                confirmButtonBuilder: _buildDismissErrorAction,
                description: errorDescription,
                title: title,
              );
            }

            return pending;
        }
      },
    );
  }
}
