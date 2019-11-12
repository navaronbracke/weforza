
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideCalendarItemBloc.dart';
import 'package:weforza/theme/appTheme.dart';

class AddRideCalendarItem extends StatefulWidget {
  AddRideCalendarItem(this.bloc): assert(bloc != null);

  final AddRideCalendarItemBloc bloc;

  @override
  _AddRideCalendarItemState createState() => _AddRideCalendarItemState();
}

class _AddRideCalendarItemState extends State<AddRideCalendarItem> {

  Color _backgroundColor;
  Color _fontColor;

  @override
  void initState() {
    super.initState();
    widget.bloc.onReset = (){
      if(widget.bloc.isNewlyScheduledRide()){
        setState(() {
          _backgroundColor = ApplicationTheme.rideCalendarFutureDayNoRideBackgroundColor;
          _fontColor = ApplicationTheme.rideCalendarFutureDayNoRideFontColor;
        });
      }
    };
    _setColors();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.bloc.onDayPressed()){
          setState(() { _setColors(); });
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: _backgroundColor,borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
          child: Text("${widget.bloc.date.day}",style: TextStyle(color: _fontColor),textAlign: TextAlign.center),
        ),
      ),
    );
  }

  void _setColors(){
    if(widget.bloc.isBeforeToday()){
      if(widget.bloc.hasRidePlanned()){
        //Past day with ride
        _backgroundColor = ApplicationTheme.rideCalendarPastDayWithRideBackgroundColor;
        _fontColor = ApplicationTheme.rideCalendarPastDayWithRideFontColor;
      }else{
        //Past day without ride
        _backgroundColor = ApplicationTheme.rideCalendarPastDayWithoutRideBackgroundColor;
        _fontColor = ApplicationTheme.rideCalendarPastDayWithoutRideFontColor;
      }
    }else{
      if(widget.bloc.hasRidePlanned()){
        if(widget.bloc.isNewlyScheduledRide()){
          //new selected date
          _backgroundColor = ApplicationTheme.rideCalendarSelectedDayBackgroundColor;
          _fontColor = ApplicationTheme.rideCalendarSelectedDayFontColor;
        }else{
          //existing date
          _backgroundColor = ApplicationTheme.rideCalendarFutureDayWithRideBackgroundColor;
          _fontColor = ApplicationTheme.rideCalendarFutureDayWithRideFontColor;
        }
      }else{
        //day without ride
        _backgroundColor = ApplicationTheme.rideCalendarFutureDayNoRideBackgroundColor;
        _fontColor = ApplicationTheme.rideCalendarFutureDayNoRideFontColor;
      }
    }
  }
}
