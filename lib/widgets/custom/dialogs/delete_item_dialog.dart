import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/cupertino_loading_dialog.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class DeleteItemDialog extends StatelessWidget {
  const DeleteItemDialog({
    super.key,
    required this.description,
    required this.errorDescription,
    required this.future,
    required this.onDeletePressed,
    required this.title,
  });

  final String description;
  final String errorDescription;
  final Future<void>? future;
  final void Function() onDeletePressed;
  final String title;

  Widget _buildAndroidConfirmDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final translator = S.of(context);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Text(title, style: textTheme.headline6),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              description,
              softWrap: true,
              style: textTheme.subtitle1,
            ),
          ),
        ),
        ButtonBar(
          children: <Widget>[
            TextButton(
              child: Text(translator.Cancel.toUpperCase()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: ApplicationTheme.deleteItemButtonTextColor,
              ),
              onPressed: onDeletePressed,
              child: Text(translator.Delete.toUpperCase()),
            ),
          ],
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidDialog(Widget content) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.biggest.width,
                height: 200,
                child: content,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidErrorDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Text(title, style: textTheme.headline6),
        ),
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(
                    Icons.error_outline,
                    size: 30,
                    color: ApplicationTheme.deleteItemButtonTextColor,
                  ),
                ),
                Text(
                  errorDescription,
                  softWrap: true,
                  style: textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ),
        ButtonBar(
          children: <Widget>[
            TextButton(
              child: Text(S.of(context).Ok.toUpperCase()),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidLoadingDialog(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(title, style: Theme.of(context).textTheme.headline6),
        ),
        const Expanded(child: Center(child: PlatformAwareLoadingIndicator())),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildIosConfirmDialog(BuildContext context) {
    final translator = S.of(context);

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onDeletePressed,
          child: Text(translator.Delete),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(translator.Cancel),
        ),
      ],
    );
  }

  Widget _buildIosErrorDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              CupertinoIcons.exclamationmark_circle,
              size: 25,
              color: CupertinoColors.destructiveRed,
            ),
          ),
          Text(errorDescription),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(S.of(context).Ok),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return PlatformAwareWidget(
                android: () => _buildAndroidErrorDialog(context),
                ios: () => _buildIosErrorDialog(context),
              );
            }

            return PlatformAwareWidget(
              android: () => _buildAndroidLoadingDialog(context),
              ios: () => const CupertinoLoadingDialog(),
            );
          default:
            return PlatformAwareWidget(
              android: () => _buildAndroidConfirmDialog(context),
              ios: () => _buildIosConfirmDialog(context),
            );
        }
      },
    );
  }
}
