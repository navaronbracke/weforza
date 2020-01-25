import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanningError.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget represents an ongoing scan [future].
///Its [onStopScan] callback allows to terminate a scan or to return from a failed scan.
class RideAttendeeAssignmentScanning extends StatelessWidget implements PlatformAwareWidget {
  RideAttendeeAssignmentScanning(this.future,this.title,this.onStopScan): assert(future != null && title != null && onStopScan != null);

  final String title;
  final Future<void> future;
  final VoidCallback onStopScan;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return RideAttendeeAssignmentScanningError(title,onStopScan);
        }else{
          return Scaffold(
            appBar: AppBar(title: Text(title,style: TextStyle(fontSize: 16))),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: _buildAnimation(),
                ),
                Flexible(
                  flex: 2,
                  child: Center(
                    child: FlatButton(
                      child: Text(S.of(context).RideAttendeeAssignmentStopScan,style: TextStyle(color: Colors.red)),
                      onPressed: onStopScan,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return RideAttendeeAssignmentScanningError(title,onStopScan);
        }else{
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              transitionBetweenRoutes: false,
              middle: Text(title),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: _buildAnimation(),
                ),
                Flexible(
                  flex: 2,
                  child: Center(
                    child: CupertinoButton(
                      child: Text(S.of(context).RideAttendeeAssignmentStopScan,style: TextStyle(color: Colors.red)),
                      onPressed: onStopScan,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildAnimation(){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: FlareActor("bluetooth_scanning.flr",animation: "scan"),
        ),
        Icon(Icons.bluetooth,size: 50,color: Colors.blue),
      ],
    );
  }
}
