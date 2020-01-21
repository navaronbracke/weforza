
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentSubmit extends StatelessWidget implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  RideAttendeeAssignmentSubmit(this.onPressed): assert(onPressed != null);

  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(
        context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context));
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context), buildIOSLandscapeLayout(context));
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 2,bottom: 2),
        child: StreamBuilder<bool>(
          initialData: false,
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Text(S.of(context).RideAttendeeAssignmentGenericError);
            }else{
              return snapshot.data ? PlatformAwareLoadingIndicator()
                  : RaisedButton(
                child: Text(S.of(context).RideAttendeeAssignmentConfirm,style: TextStyle(color: Colors.white)),
                onPressed: () => onPressed(),
                color: ApplicationTheme.rideAttendeeSubmitButtonColor,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        child: StreamBuilder<bool>(
          initialData: false,
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Text(S.of(context).RideAttendeeAssignmentGenericError);
            }else{
              return snapshot.data ? PlatformAwareLoadingIndicator()
                  : RaisedButton(
                      child: Text(S.of(context).RideAttendeeAssignmentConfirm,style: TextStyle(color: Colors.white)),
                      onPressed: () => onPressed(),
                      color: ApplicationTheme.rideAttendeeSubmitButtonColor,
                  );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 2,bottom: 2),
        child: StreamBuilder<bool>(
          initialData: false,
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Text(S.of(context).RideAttendeeAssignmentGenericError);
            }else{
              return snapshot.data ? PlatformAwareLoadingIndicator()
                  : CupertinoButton(
                      child: Text(S.of(context).RideAttendeeAssignmentConfirm,style: TextStyle(color: Colors.white)),
                      onPressed: () => onPressed(),
                      color: ApplicationTheme.rideAttendeeSubmitButtonColor,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        child: StreamBuilder<bool>(
          initialData: false,
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Text(S.of(context).RideAttendeeAssignmentGenericError);
            }else{
              return snapshot.data ? PlatformAwareLoadingIndicator()
                  : CupertinoButton(
                    child: Text(S.of(context).RideAttendeeAssignmentConfirm,style: TextStyle(color: Colors.white)),
                    onPressed: () => onPressed(),
                    color: ApplicationTheme.rideAttendeeSubmitButtonColor,
              );
            }
          },
        ),
      ),
    );
  }
}
