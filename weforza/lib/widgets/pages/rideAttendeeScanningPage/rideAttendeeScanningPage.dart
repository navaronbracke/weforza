import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeScanningPage extends StatefulWidget {
  @override
  _RideAttendeeScanningPageState createState() => _RideAttendeeScanningPageState();
}

class _RideAttendeeScanningPageState extends State<RideAttendeeScanningPage> {

  //TODO manage state by bloc object

  bool isScanStep = true;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIOSLayout(context),
    );
  }

  Widget _buildAndroidLayout(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Text(
                S.of(context).RideAttendeeScanningProcessScanLabel.toUpperCase(),
                style: TextStyle(color: isScanStep ? ApplicationTheme.androidRideAttendeeScanProcessCurrentStepColor:
                  ApplicationTheme.androidRideAttendeeScanProcessOtherStepColor)
            ),
            SizedBox(
              width: 50,
              child: Center(
                  child: Icon(
                      Icons.arrow_forward_ios,
                      color: isScanStep ? ApplicationTheme.androidRideAttendeeScanProcessCurrentStepColor:
                        ApplicationTheme.androidRideAttendeeScanProcessOtherStepColor
                  )
              ),
            ),
            Text(
              S.of(context).RideAttendeeScanningProcessAddMembersLabel.toUpperCase(),
              style: TextStyle(color: isScanStep ? ApplicationTheme.androidRideAttendeeScanProcessOtherStepColor:
                ApplicationTheme.androidRideAttendeeScanProcessCurrentStepColor
              ) ,
            ),
          ],
        ),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Wissel van stap"),
          onPressed: () => setState((){
            isScanStep = !isScanStep;
          }),
        ),
      ),
    );
  }

  Widget _buildIOSLayout(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        automaticallyImplyLeading: false,
        middle: Row(
          children: <Widget>[
            Text(
                S.of(context).RideAttendeeScanningProcessScanLabel.toUpperCase(),
                style: TextStyle(color: isScanStep ? ApplicationTheme.iosRideAttendeeScanProcessCurrentStepColor:
                  ApplicationTheme.iosRideAttendeeScanProcessOtherStepColor)
            ),
            SizedBox(
              width: 50,
              child: Center(
                  child: Icon(
                      Icons.arrow_forward_ios,
                      color: isScanStep ? ApplicationTheme.iosRideAttendeeScanProcessCurrentStepColor:
                        ApplicationTheme.iosRideAttendeeScanProcessOtherStepColor
                  )
              ),
            ),
            Text(
              S.of(context).RideAttendeeScanningProcessAddMembersLabel.toUpperCase(),
              style: TextStyle(color: isScanStep ? ApplicationTheme.iosRideAttendeeScanProcessOtherStepColor:
                ApplicationTheme.iosRideAttendeeScanProcessCurrentStepColor
              ) ,
            ),
          ],
        ),
      ),
      child: Center(
        child: CupertinoButton(
          child: Text("Wissel van stap"),
          onPressed: () => setState((){
            isScanStep = !isScanStep;
          }),
        ),
      ),
    );
  }
}
