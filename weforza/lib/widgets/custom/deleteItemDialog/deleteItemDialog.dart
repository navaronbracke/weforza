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
        ),
      ],
    );
    return _buildAndroidDialog(content);
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
              TextButton(
                child: Text(S.of(context).Ok.toUpperCase()),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ],
    );
    return _buildAndroidDialog(content);
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
    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidDialog(Widget content){
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 280,//280 is the minimum for a material Dialog
            height: 200,
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildIosConfirmDialog(BuildContext context){
    final content = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: '.SF UI Display',
              inherit: false,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.description,
              style: TextStyle(
                color: Colors.black,
                fontFamily: '.SF UI Text',
                inherit: false,
                fontSize: 13.4,
                fontWeight: FontWeight.w400,
                height: 1.036,
                letterSpacing: -0.25,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Center(
                  child: CupertinoDialogAction(
                    child: Text(S.of(context).Cancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: CupertinoDialogAction(
                    child: Text(
                      S.of(context).Delete,
                      style: TextStyle(
                        color: ApplicationTheme.deleteItemButtonTextColor
                        ),
                      ),
                    onPressed: () => _onConfirmDeletion(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return _buildIosDialog(content);
  }

  Widget _buildIosErrorDialog(BuildContext context){
    final content = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: '.SF UI Display',
              inherit: false,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
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
                      size: 25,
                      color: ApplicationTheme.deleteItemButtonTextColor
                  ),
                ),
                Text(
                  widget.errorDescription,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: '.SF UI Text',
                    inherit: false,
                    fontSize: 13.4,
                    fontWeight: FontWeight.w400,
                    height: 1.036,
                    letterSpacing: -0.25,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: CupertinoDialogAction(
                    child: Text(S.of(context).Ok),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return _buildIosDialog(content);
  }

  Widget _buildIosLoadingDialog(BuildContext context){
    final content = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: '.SF UI Display',
              inherit: false,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
        Expanded(
          child: Center(child: PlatformAwareLoadingIndicator())
        ),
      ],
    );
    return _buildIosDialog(content);
  }

  ///Build the general dialog scaffolding and inject the content.
  ///This way, the general look is the same for each dialog,
  ///but the content can differ.
  Widget _buildIosDialog(Widget content){
    return Center(
      child: CupertinoPopupSurface(
      isSurfacePainted: true,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
            SizedBox(
              width: 270.0,
              height: 200,
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirmDeletion() {
    deleteItemFuture = widget.onDelete();
    setState(() {});
  }
}
