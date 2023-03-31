import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This dialog handles the UI for a delete item confirmation.
class DeleteItemDialog extends StatefulWidget {
  DeleteItemDialog({
    @required this.onDelete,
    @required this.title,
    @required this.description,
    @required this.errorDescription,
  }): assert(
    onDelete != null && title != null && title.isNotEmpty
        && description != null && description.isNotEmpty
        && errorDescription != null && errorDescription.isNotEmpty
  );

  //This lambda generates the delete computation.
  final Future<void> Function() onDelete;
  final String title;
  final String description;
  final String errorDescription;

  @override
  _DeleteItemDialogState createState() => _DeleteItemDialogState();
}

class _DeleteItemDialogState extends State<DeleteItemDialog> {

  Future<void> deleteItemFuture;
  //TODO IOS version

  @override
  Widget build(BuildContext context){
    return FutureBuilder<void>(
      future: deleteItemFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.none){
          return PlatformAwareWidget(
            android: () => _buildAndroidConfirmDialog(context),
            ios: () => _buildIosConfirmDialog(context),
          );
        }else if(snapshot.connectionState == ConnectionState.done && snapshot.hasError){
          return PlatformAwareWidget(
            android: () => _buildAndroidErrorDialog(context),
            ios: () => _buildIosErrorDialog(context),
          );
        }else{
          return PlatformAwareWidget(
            android: () => _buildAndroidLoadingDialog(context),
            ios: () => _buildIosLoadingDialog(context),
          );
        }
      },
    );
  }

  Widget _buildAndroidConfirmDialog(BuildContext context){
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
                widget.description,
                softWrap: true,
                style: Theme.of(context).textTheme.subtitle1
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(S.of(context).DialogCancel.toUpperCase()),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(S.of(context).DialogDelete.toUpperCase()),
                textColor: ApplicationTheme.deleteItemButtonTextColor,
                onPressed: () => _onConfirmDeletion(),
              ),
            ],
          ),
        ),
      ],
    );
    return _buildAndroidDialog(context, content);
  }

  Widget _buildAndroidErrorDialog(BuildContext context){
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Icon(
                      Icons.error_outline,
                      size: 30,
                      color: ApplicationTheme.deleteItemButtonTextColor
                  ),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(S.of(context).DialogDismiss.toUpperCase()),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ],
    );
    return _buildAndroidDialog(context, content);
  }

  Widget _buildAndroidLoadingDialog(BuildContext context){
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        Expanded(
          child: Center(child: PlatformAwareLoadingIndicator()),
        ),
      ],
    );
    return _buildAndroidDialog(context, content);
  }

  Widget _buildAndroidDialog(BuildContext context, Widget content){
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 280,
            height: 200,
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildIosConfirmDialog(BuildContext context){
    //TODO title + description + padding + confirm + cancel
  }

  Widget _buildIosErrorDialog(BuildContext context){
    //TODO title + padding + dismiss button + error description
  }

  Widget _buildIosLoadingDialog(BuildContext context){
    //TODO title + loading indicator in the center + padding
  }

  ///Build the general dialog scaffolding and inject the content.
  ///This way, the general look is the same for each dialog,
  ///but the content can differ.
  Widget _buildIosDialog(){
    //popupsurface + title in middle + content
    //figure out how to do the view insets
  }

  void _onConfirmDeletion() {
    deleteItemFuture = widget.onDelete();
    setState(() {});
  }
}
