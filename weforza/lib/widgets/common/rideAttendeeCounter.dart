import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeCounter extends StatelessWidget {
  RideAttendeeCounter({
    @required this.future,
    this.iconSize = 24,
    this.counterStyle,
    this.invisibleWhenLoadingOrError = false,
  }): assert(future != null);

  final double iconSize;
  final TextStyle counterStyle;
  final Future<int> future;
  final bool invisibleWhenLoadingOrError;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return invisibleWhenLoadingOrError ? SizedBox.expand(): Row(
              children: <Widget>[
                Text("?", style: counterStyle),
                SizedBox(width: 5),
                Icon(
                    Icons.people,
                    size: iconSize,
                    color: ApplicationTheme.rideAttendeeCounterIconColor
                ),
              ],
            );
          }else{
            return Row(
              children: <Widget>[
                Text("${snapshot.data}", style: counterStyle),
                SizedBox(width: 5),
                Icon(
                    Icons.people,
                    size: iconSize,
                    color: ApplicationTheme.rideAttendeeCounterIconColor
                ),
              ],
            );
          }
        }else{
          return SizedBox(
            width: iconSize,
            height: iconSize,
            child: Center(
              child: invisibleWhenLoadingOrError ? null : PlatformAwareWidget(
                android: () => SizedBox(
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  width: iconSize * .8,
                  height: iconSize * .8,
                ),
                ios: () => CupertinoActivityIndicator(radius: 8),
              ),
            ),
          );
        }
      },
    );
  }
}
