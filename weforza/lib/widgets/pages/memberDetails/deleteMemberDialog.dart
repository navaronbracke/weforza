
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class MemberDeleteHandler {
  Future<void> deleteMember();
}

///This [Widget] is the dialog for deleting a member in [MemberDetailsPage].
class DeleteMemberDialog extends StatefulWidget {
  DeleteMemberDialog(this._handler): assert(_handler != null);

  ///The Bloc that handles a submit.
  final MemberDeleteHandler _handler;

  @override
  _DeleteMemberDialogState createState() => _DeleteMemberDialogState();

}

class _DeleteMemberDialogState extends State<DeleteMemberDialog> implements PlatformAwareWidget {

  bool hasError = false;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: hasError ? null : Text(S.of(context).MemberDeleteDialogTitle),
      content: hasError ? Text(S.of(context).MemberDeleteDialogErrorDescription) : Text(S.of(context).MemberDeleteDialogDescription),
      actions: hasError ? <Widget>[
        FlatButton(
          child: Text(S.of(context).DialogOk),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
      ]: <Widget>[
        FlatButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
        FlatButton(
          child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await widget._handler.deleteMember().then((_){
              Navigator.pop(context,true);
            },onError: (error){
              setState(() {
                hasError = true;
              });
            });
          },
        ),
      ],
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: hasError ? null : Text(S.of(context).MemberDeleteDialogTitle),
      content: hasError ? Text(S.of(context).MemberDeleteDialogErrorDescription) : Text(S.of(context).MemberDeleteDialogDescription),
      actions: hasError ? <Widget>[
        CupertinoButton(
          child: Text(S.of(context).DialogOk),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
      ]: <Widget>[
        CupertinoButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
        CupertinoButton(
          child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await widget._handler.deleteMember().then((_){
              Navigator.pop(context,true);
            },onError: (error){
              setState(() {
                hasError = true;
              });
            });
          },
        ),
      ],
    );
  }
}