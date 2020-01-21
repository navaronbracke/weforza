
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class MemberDeleteHandler {
  Future<void> deleteMember(String uuid);
}

///This [Widget] is the dialog for deleting a member in [MemberDetailsPage].
class DeleteMemberDialog extends StatefulWidget {
  DeleteMemberDialog(this._handler,this._memberId): assert(_handler != null && _memberId != null);

  ///The Bloc that handles a submit.
  final MemberDeleteHandler _handler;
  final String _memberId;

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
            Navigator.pop(context);
          },
        ),
      ]: <Widget>[
        FlatButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await widget._handler.deleteMember(widget._memberId).then((_){
              MemberProvider.reloadMembers = true;
              final navigator = Navigator.of(context);
              //Pop both the dialog and the detail screen
              navigator.pop();
              navigator.pop();
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
            Navigator.pop(context);
          },
        ),
      ]: <Widget>[
        CupertinoButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        CupertinoButton(
          child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await widget._handler.deleteMember(widget._memberId).then((_){
              MemberProvider.reloadMembers = true;
              final navigator = Navigator.of(context);
              //Pop both the dialog and the detail screen
              navigator.pop();
              navigator.pop();
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