import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/deviceFoundPopUp.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeScanningProgressBar.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/i18n.dart';


class RideAttendeeAssignmentScanning extends StatelessWidget {
  RideAttendeeAssignmentScanning({
    @required this.duration,
    @required this.onStopScan,
    @required this.deviceStream,
  }): assert(
    onStopScan != null && deviceStream != null && duration != null
        && duration > 0
  );

  final int duration;
  final VoidCallback onStopScan;
  final Stream<String> deviceStream;

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: _buildPulseAnimation(context),
        ),
        Flexible(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 70,
                child: StreamBuilder<String>(
                  initialData: "",
                  stream: deviceStream,
                  builder: (context,snapshot)=> snapshot.data.isEmpty ?
                    Container():
                    DeviceFoundPopup(
                        deviceName: S.of(context).DeviceFound(snapshot.data)
                    ),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Center(),
                  ),
                  Flexible(
                    child: RideAttendeeScanningProgressBar(
                      duration: duration,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildStopButton(S.of(context).RideAttendeeAssignmentStopScan)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPulseAnimation(BuildContext context){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: FlareActor("assets/bluetooth_scanning.flr",animation: "scan"),
        ),
        Icon(Icons.bluetooth,size: MediaQuery.of(context).size.shortestSide * .1,color: Colors.blue),
      ],
    );
  }

  Widget _buildStopButton(String text){
    return PlatformAwareWidget(
      android: () => FlatButton(
        child: Text(text,style: TextStyle(color: Colors.red)),
        onPressed: onStopScan,
      ),
      ios: () => CupertinoButton(
        child: Text(text,style: TextStyle(color: Colors.red)),
        onPressed: onStopScan,
      ),
    );
  }
}