import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';


abstract class RideDeleteHandler {
  Future<void> deleteRide(DateTime date);
}

class DeleteRideDialog extends StatefulWidget {
  DeleteRideDialog(this._handler): assert(_handler != null);

  final RideDeleteHandler _handler;

  @override
  _DeleteRideDialogState createState() => _DeleteRideDialogState();
}

class _DeleteRideDialogState extends State<DeleteRideDialog> implements PlatformAwareWidget {

  bool hasError = false;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: hasError ? null : Text(S.of(context).RideDeleteDialogTitle),
      content: hasError ? Text(S.of(context).RideDeleteDialogErrorDescription) : Text(S.of(context).RideDeleteDialogDescription),
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
            await widget._handler.deleteRide(RideProvider.selectedRide.date).then((_){
              RideProvider.reloadRides = true;
              final navigator = Navigator.of(context);
              //Pop the dialog and the detail off the stack
              navigator.pop(context);
              navigator.pop(context);
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
      title: hasError ? null : Text(S.of(context).RideDeleteDialogTitle),
      content: hasError ? Text(S.of(context).RideDeleteDialogErrorDescription) : Text(S.of(context).RideDeleteDialogDescription),
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
            await widget._handler.deleteRide(RideProvider.selectedRide.date).then((_){
              RideProvider.reloadRides = true;
              final navigator = Navigator.of(context);
              //Pop the dialog and the detail off the stack
              navigator.pop(context);
              navigator.pop(context);
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
