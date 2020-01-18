
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/attendeeScanner.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentScanning extends StatefulWidget {
  RideAttendeeAssignmentScanning(this.title,this.scanner): assert(title != null && scanner != null);

  final String title;
  final AttendeeScanner scanner;

  @override
  _RideAttendeeAssignmentScanningState createState() => _RideAttendeeAssignmentScanningState();
}

class _RideAttendeeAssignmentScanningState extends State<RideAttendeeAssignmentScanning> with SingleTickerProviderStateMixin implements PlatformAwareWidget {
  AnimationController _scanAnimationController;
  Animation _colorTween;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(vsync: this,duration: Duration(milliseconds: 400))
      ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scanAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _scanAnimationController.forward();
      }
    });
    _colorTween = ColorTween(
        begin: ApplicationTheme.bluetoothScanningAnimationStartColor,
        end: ApplicationTheme.bluetoothScanningAnimationEndColor)
        .animate(_scanAnimationController);
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: AnimatedBuilder(
                animation: _colorTween,
                builder: (context,child)=> Icon(Icons.bluetooth,color: _colorTween.value),
              ),
            ),
            Flexible(
              flex: 2,
              child: Center(
                child: FlatButton(
                  child: Text(S.of(context).RideAttendeeAssignmentStopScan,style: TextStyle(color: Colors.red)),
                  onPressed: (){
                    widget.scanner.stopScan();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(widget.title),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: AnimatedBuilder(
                animation: _colorTween,
                builder: (context,child)=> Icon(Icons.bluetooth,color: _colorTween.value),
              ),
            ),
            Flexible(
              flex: 2,
              child: Center(
                child: CupertinoButton(
                  child: Text(S.of(context).RideAttendeeAssignmentStopScan,style: TextStyle(color: Colors.red)),
                  onPressed: (){
                    widget.scanner.stopScan();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scanAnimationController.dispose();
  }
}
