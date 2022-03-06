import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoLoadingDialog.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This dialog handles the UI for a delete item confirmation.
class DeleteItemDialog extends StatefulWidget {
  DeleteItemDialog({
    Key? key,
    required this.onDelete,
    required this.title,
    required this.description,
    required this.errorDescription,
  })  : assert(title.isNotEmpty &&
            description.isNotEmpty &&
            errorDescription.isNotEmpty),
        super(key: key);

  //This lambda generates the delete computation.
  final Future<void> Function() onDelete;
  final String title;
  final String description;
  final String errorDescription;

  @override
  _DeleteItemDialogState createState() => _DeleteItemDialogState();
}

class _DeleteItemDialogState extends State<DeleteItemDialog> {
  Future<void>? deleteItemFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: deleteItemFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return PlatformAwareWidget(
            android: () => _buildAndroidConfirmDialog(context),
            ios: () => _buildIosConfirmDialog(context),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          return PlatformAwareWidget(
            android: () => _buildAndroidErrorDialog(context),
            ios: () => _buildIosErrorDialog(context),
          );
        } else {
          return PlatformAwareWidget(
            android: () => _buildAndroidLoadingDialog(context),
            ios: () => const CupertinoLoadingDialog(),
          );
        }
      },
    );
  }

  Widget _buildAndroidConfirmDialog(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child:
              Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(widget.description,
                softWrap: true, style: Theme.of(context).textTheme.subtitle1),
          ),
        ),
        ButtonBar(
          children: <Widget>[
            TextButton(
              child: Text(S.of(context).Cancel.toUpperCase()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(S.of(context).Delete.toUpperCase()),
              style: TextButton.styleFrom(
                primary: ApplicationTheme.deleteItemButtonTextColor,
              ),
              onPressed: () => _onConfirmDeletion(),
            ),
          ],
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidErrorDialog(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child:
              Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Icon(Icons.error_outline,
                      size: 30,
                      color: ApplicationTheme.deleteItemButtonTextColor),
                ),
                Text(
                  widget.errorDescription,
                  softWrap: true,
                  style: Theme.of(context).textTheme.subtitle1,
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
          child:
              Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        const Expanded(
          child: Center(child: PlatformAwareLoadingIndicator()),
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

  Widget _buildIosConfirmDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Text(widget.description),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(S.of(context).Delete),
          onPressed: () => _onConfirmDeletion(),
        ),
        CupertinoDialogAction(
          child: Text(S.of(context).Cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildIosErrorDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
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
          Text(widget.errorDescription),
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

  void _onConfirmDeletion() {
    deleteItemFuture = widget.onDelete();

    setState(() {});
  }
}
