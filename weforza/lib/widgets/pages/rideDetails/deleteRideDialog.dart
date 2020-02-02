import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class DeleteRideHandler {
  Future<void> deleteRide();
}

class DeleteRideDialog extends StatefulWidget {
  DeleteRideDialog(this.deleteHandler): assert(deleteHandler != null);

  final DeleteRideHandler deleteHandler;

  @override
  _DeleteRideDialogState createState() => _DeleteRideDialogState();
}

class _DeleteRideDialogState extends State<DeleteRideDialog> implements PlatformAwareWidget {
  Future<void> deleteRideFuture;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: deleteRideFuture,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.none){
          return AlertDialog(
            title: Text(S.of(context).RideDeleteDialogTitle),
            content: Text(S.of(context).RideDeleteDialogDescription),
            actions: <Widget>[
              FlatButton(
                child: Text(S.of(context).DialogCancel),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    deleteRideFuture = widget.deleteHandler.deleteRide().then((_){
                      RideProvider.reloadRides = true;
                      final navigator = Navigator.of(context);
                      //Pop both the dialog and the detail screen
                      navigator.pop();
                      navigator.pop();
                    });
                  });
                },
              ),
            ],
          );
        }else if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return AlertDialog(
              content: Text(S.of(context).RideDeleteDialogErrorDescription),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).DialogOk),
                  onPressed: ()=> Navigator.pop(context),
                ),
              ],
            );
          }else{
            return Dialog(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Center(child: PlatformAwareLoadingIndicator()),
              ),
            );
          }
        }else{
          return Dialog(
            child: SizedBox(
              width: 280,
              height: 280,
              child: Center(child: PlatformAwareLoadingIndicator()),
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: deleteRideFuture,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.none){
          return CupertinoAlertDialog(
            title: Text(S.of(context).RideDeleteDialogTitle),
            content: Text(S.of(context).RideDeleteDialogDescription),
            actions: <Widget>[
              CupertinoButton(
                child: Text(S.of(context).DialogCancel),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              CupertinoButton(
                child: Text(S.of(context).DialogDelete,style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    deleteRideFuture = widget.deleteHandler.deleteRide().then((_){
                      RideProvider.reloadRides = true;
                      final navigator = Navigator.of(context);
                      //Pop both the dialog and the detail screen
                      navigator.pop();
                      navigator.pop();
                    });
                  });
                },
              ),
            ],
          );
        }else if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return CupertinoAlertDialog(
              content: Text(S.of(context).RideDeleteDialogErrorDescription),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(S.of(context).DialogOk),
                  onPressed: ()=> Navigator.pop(context),
                ),
              ],
            );
          }else{
            return CupertinoAlertDialog(
              content: SizedBox(
                width: 140,
                height: 140,
                child: Center(child: PlatformAwareLoadingIndicator()),
              ),
            );
          }
        }else{
            return CupertinoAlertDialog(
              content: SizedBox(
                width: 140,
                height: 140,
                child: Center(child: PlatformAwareLoadingIndicator()),
              ),
            );
        }
      },
    );
  }
}
