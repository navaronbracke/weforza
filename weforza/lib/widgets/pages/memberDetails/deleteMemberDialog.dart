
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class MemberDeleteHandler {
  Future<void> deleteMember();
}

///This [Widget] is the dialog for deleting a member in [MemberDetailsPage].
class DeleteMemberDialog extends StatelessWidget implements PlatformAwareWidget {
  DeleteMemberDialog(this._handler): assert(_handler != null);

  ///The Bloc that handles a submit.
  final MemberDeleteHandler _handler;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).MemberDeleteDialogTitle),
      content: Text(S.of(context).MemberDeleteDialogDescription),
      actions: <Widget>[
        FlatButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
        FlatButton(
          child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await _handler.deleteMember();
            Navigator.pop(context,true);
          },
        ),
      ],
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(S.of(context).MemberDeleteDialogTitle),
      content: Text(S.of(context).MemberDeleteDialogDescription),
      actions: <Widget>[
        CupertinoButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
        CupertinoButton(
          child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await _handler.deleteMember();
            Navigator.pop(context,true);
          },
        ),
      ],
    );
  }
}