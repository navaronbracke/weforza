import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeCounter extends StatelessWidget {
  RideAttendeeCounter({@required this.future,this.iconSize,this.counterStyle})
      : assert(future != null);

  final double iconSize;
  final TextStyle counterStyle;
  final Future<int> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Row(
              children: <Widget>[
                counterStyle == null ? Text("?"): Text("?",style: counterStyle),
                SizedBox(width: 5),
                Icon(Icons.people,size: iconSize ?? 24,color: ApplicationTheme.rideAttendeeCounterIconColor),
              ],
            );
          }else{
            return Row(
              children: <Widget>[
                counterStyle == null ? Text("${snapshot.data}"): Text("${snapshot.data}",style: counterStyle),
                SizedBox(width: 5),
                Icon(Icons.people,size: iconSize ?? 24,color: ApplicationTheme.rideAttendeeCounterIconColor),
              ],
            );
          }
        }else{
          return Row(
            children: <Widget>[
              SizedBox(
                width: iconSize ?? 24,
                height: iconSize ?? 24,
                child: PlatformAwareWidget(
                  android: () => CircularProgressIndicator(strokeWidth: 2),
                  ios: () => CupertinoActivityIndicator(radius: 8),
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.people,size: iconSize ?? 24,color: ApplicationTheme.rideAttendeeCounterIconColor),
            ],
          );
        }
      },
    );
  }
}
