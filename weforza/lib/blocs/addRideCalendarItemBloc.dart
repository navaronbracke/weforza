
import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/bloc.dart';

///This class represents a BLoC for an AddRideCalendarItem.
class AddRideCalendarItemBloc extends Bloc {
  AddRideCalendarItemBloc(this.date,this.scheduler): assert(date != null && scheduler != null);

  final DateTime date;
  final IRideDayScheduler scheduler;
  VoidCallback _onReset;

  bool isBeforeToday(){
    DateTime today = DateTime.now();
    return date.isBefore(DateTime(today.year,today.month,today.day));
  }

  @override
  void dispose() {}

  set onReset(VoidCallback function) => _onReset = function;

  void reset(){
    if(_onReset != null)
    {
      _onReset();
    }
  }

  bool onDayPressed() => scheduler.onDayPressed(date);

  bool hasRidePlanned() => scheduler.hasRidePlanned(date);

  bool isNewlyScheduledRide() => scheduler.isNewlyScheduledRide(date);
}

///This interface represents a contract for checking a ride's date against a schedule of existing dates.
abstract class IRideDayScheduler {
  bool hasRidePlanned(DateTime date);

  bool isNewlyScheduledRide(DateTime date);

  bool onDayPressed(DateTime date);
}