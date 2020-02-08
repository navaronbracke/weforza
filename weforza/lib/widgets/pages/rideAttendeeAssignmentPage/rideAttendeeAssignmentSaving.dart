import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentError.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentSaving extends StatelessWidget {
  RideAttendeeAssignmentSaving(this.future,this.title):
        assert(future != null && title != null);

  final String title;
  final Future<void> future;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasError){
          return RideAttendeeAssignmentError(title);
        }else{
          return Scaffold(
            appBar: AppBar(title: Text(title,style: TextStyle(fontSize: 16))),
            body: Center(child: PlatformAwareLoadingIndicator()),
          );
        }
      },
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasError){
          return RideAttendeeAssignmentError(title);
        }else{
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              transitionBetweenRoutes: false,
              middle: Text(title),
            ),
            child: Center(child: PlatformAwareLoadingIndicator()),
          );
        }
      },
    );
  }
}

