
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/providers/addRideBlocProvider.dart';

class AddRideCalendarItem extends StatefulWidget {
  AddRideCalendarItem({@required this.date}): assert(date != null);

  final DateTime date;

  @override
  _AddRideCalendarItemState createState() => _AddRideCalendarItemState();
}

class _AddRideCalendarItemState extends State<AddRideCalendarItem> {

  Color _backgroundColor;
  Color _fontColor;
  ///The on reset callback
  VoidCallback _onReset;

  AddRideBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = AddRideBlocProvider.of(context).bloc;
    _onReset = () {
      if(mounted) {
        setState(() { _setColors(_bloc); });
      }
    };
    _bloc.registerResetFunction(_onReset);
    _setColors(_bloc);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = AddRideBlocProvider.of(context).bloc;
    return GestureDetector(
      onTap: (){
        //Update the widget if allowed
        if(mounted && bloc.onDayPressed(widget.date)){
          setState(() { _setColors(bloc); });
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: _backgroundColor,borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
          child: Text("${widget.date.day}",style: TextStyle(color: _fontColor),textAlign: TextAlign.center),
        ),
      ),
    );
  }

  ///Update the colors for the widget.
  void _setColors(AddRideBloc bloc){
    if(bloc.isBeforeToday(widget.date)){
      if(bloc.dayIsNewlyScheduledRide(widget.date)){
        //Past day with ride
        _backgroundColor = ApplicationTheme.rideCalendarPastDayWithRideBackgroundColor;
        _fontColor = ApplicationTheme.rideCalendarPastDayWithRideFontColor;
      }else{
        //Past day without ride
        _backgroundColor = ApplicationTheme.rideCalendarPastDayWithoutRideBackgroundColor;
        _fontColor = ApplicationTheme.rideCalendarPastDayWithoutRideFontColor;
      }
    }else{
      if(bloc.dayHasRidePlanned(widget.date)){
        if(bloc.dayIsNewlyScheduledRide(widget.date)){
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

  @override
  void dispose() {
    _bloc.unregisterResetFunction(_onReset);
    _onReset = null;
    super.dispose();
  }
}
