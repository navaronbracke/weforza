import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:weforza/model/rideCalendarEvent.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/addRideCalendar/iRidePicker.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a Calendar for picking Ride dates.
class AddRideCalendar extends StatefulWidget {
  AddRideCalendar(this.picker): assert(picker != null);

  ///The handler for this [Widget].
  final IRidePicker picker;

  @override
  _AddRideCalendarState createState() => _AddRideCalendarState();
}

class _AddRideCalendarState extends State<AddRideCalendar> implements PlatformAwareWidget {

  ///Today stamp time variable.
  DateTime today;

  ///Build the Calendar.
  Widget _buildCalendar() {
    return CalendarCarousel<RideCalendarEvent>(
      onDayPressed: (date,events){
        if(widget.picker.onDayPressed(date,events)){
          setState(() {});
        }
      },
      onDayLongPressed: (date){
        //Do nothing
      },
      selectedDateTime: widget.picker.selectedDate,
      daysHaveCircularBorder: null,
      markedDatesMap: widget.picker.markedDates,
      weekendTextStyle: ApplicationTheme.rideCalendarDayStyle,
      weekdayTextStyle: ApplicationTheme.rideCalendarDayStyle,
      customWeekDayBuilder: (day,text){
        switch(day){
          case 0:
            return Expanded(child: Center(child: Text(S.of(context).MondayPrefix,textAlign: TextAlign.center)));
          case 1:
            return Expanded(child: Center(child: Text(S.of(context).TuesdayPrefix,textAlign: TextAlign.center)));
          case 2:
            return Expanded(child: Center(child: Text(S.of(context).WednesdayPrefix,textAlign: TextAlign.center)));
          case 3:
            return Expanded(child: Center(child: Text(S.of(context).ThursdayPrefix,textAlign: TextAlign.center)));
          case 4:
            return Expanded(child: Center(child: Text(S.of(context).FridayPrefix,textAlign: TextAlign.center)));
          case 5:
            return Expanded(child: Center(child: Text(S.of(context).SaturdayPrefix,textAlign: TextAlign.center)));
          case 6:
            return Expanded(child: Center(child: Text(S.of(context).SundayPrefix,textAlign: TextAlign.center)));
        }
        return Text("");
      },
      locale: Localizations.localeOf(context).languageCode,
      customDayBuilder: (
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day){
          if(day.isBefore(today)){
            if(widget.picker.dayHasRidePlanned(day)){
              return _pastDayWithRide(day.day);
            }else{
              return _pastDayWithoutRide(day.day);
            }
          }else if(widget.picker.dayHasRidePlanned(day)){
            return _dayWithAlreadyPlannedRide(day.day);
          }else if(widget.picker.dayIsNewlyScheduledRide(day)){
            return _dayWithNewlyPlannedRide(day.day);
          }else{
            return null;
          }
      },
      markedDateWidget: Center(),
      todayButtonColor: null,
    );
  }

  @override
  void initState() {
    today = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.build(context, this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return _buildCalendar();
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Material(
      child: _buildCalendar(),
    );
  }

  ///Build a [Widget] for a day in the past, that didn't have a ride.
  Widget _pastDayWithoutRide(int day){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: ApplicationTheme.rideCalendarPastDayNoRideColor
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Center(child: Text("$day",textAlign: TextAlign.center,style: ApplicationTheme.rideCalendarDayBuilderStyle)),
        ),
      ),
    );
  }

  ///Build a [Widget] for a day in the past, that did have a ride.
  Widget _pastDayWithRide(int day){
    return Center(
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: ApplicationTheme.rideCalendarPastDayWithRideColor
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Center(child: Text("$day",textAlign: TextAlign.center,style: ApplicationTheme.rideCalendarDayBuilderStyle)),
        ),
      ),
    );
  }

  ///Build a [Widget] for a day in the future, which already had a ride planned.
  Widget _dayWithAlreadyPlannedRide(int day){
    return Center(
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Center(child: Text("$day",textAlign: TextAlign.center,style: ApplicationTheme.rideCalendarDayBuilderStyle)),
        ),
      ),
    );
  }

  ///Build a [Widget] for a day that just got a ride planned right now.
  Widget _dayWithNewlyPlannedRide(int day){
    return Center(
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).accentColor
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Center(child: Text("$day",textAlign: TextAlign.center,style: ApplicationTheme.rideCalendarDayBuilderStyle)),
        ),
      ),
    );
  }
}
