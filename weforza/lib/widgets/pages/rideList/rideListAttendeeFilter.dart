import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideListAttendeeFilter extends StatefulWidget {
  RideListAttendeeFilter(this.state,this.handler): assert(state != null && handler != null);

  final AttendeeFilterState state;

  final AttendeeFilterHandler handler;

  @override
  _RideListAttendeeFilterState createState() => _RideListAttendeeFilterState();
}

class _RideListAttendeeFilterState extends State<RideListAttendeeFilter> implements PlatformAwareWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    if(widget.state == AttendeeFilterState.ON){
      return Switch(
          activeTrackColor: Theme.of(context).accentColor,
          activeColor: Colors.white,
          value: true,
          onChanged: (value) {
            widget.handler.turnOffFilter();
          }
      );
    }else if(widget.state == AttendeeFilterState.OFF){
      return Switch(
          activeTrackColor: Theme.of(context).accentColor,
          activeColor: Colors.white,
          value: false,
          onChanged: (value) {
            widget.handler.turnOnFilter();
          }
      );
    }else{
      return Switch(
        activeTrackColor: Theme.of(context).accentColor,
        activeColor: Colors.white,
        value: false,
        onChanged: null,
      );
    }
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    if(widget.state == AttendeeFilterState.ON){
      return CupertinoSwitch(
        activeColor: CupertinoTheme.of(context).primaryContrastingColor,
        value: true,
        onChanged: (value){
          widget.handler.turnOffFilter();
        },
      );
    }else if(widget.state == AttendeeFilterState.OFF){
      return CupertinoSwitch(
        activeColor: CupertinoTheme.of(context).primaryContrastingColor,
        value: false,
        onChanged: (value){
          widget.handler.turnOnFilter();
        },
      );
    }else{
      return CupertinoSwitch(
        activeColor: CupertinoTheme.of(context).primaryContrastingColor,
        value: false,
        onChanged: null,
      );
    }
  }
}

abstract class AttendeeFilterHandler {
  void turnOnFilter();

  void turnOffFilter();
}
