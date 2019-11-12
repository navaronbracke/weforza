
import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/bloc.dart';

///This class represents a BLoC for an AddRideCalendarItem.
class AddRideCalendarItemBloc extends Bloc {
  AddRideCalendarItemBloc(this.date,this.scheduler): assert(date != null && scheduler != null);

  ///The date for the item.
  final DateTime date;
  ///The [IRideDayScheduler] for this bloc.
  final IRideDayScheduler scheduler;
  ///The internal on reset callback.
  VoidCallback _onReset;

  ///Whether [date] is before today.
  bool isBeforeToday(){
    DateTime today = DateTime.now();
    return date.isBefore(DateTime(today.year,today.month,today.day));
  }

  @override
  void dispose() {}

  ///Set [_onReset] to a new value.
  set onReset(VoidCallback function) => _onReset = function;

  ///Call [_onReset] if possible.
  void reset(){
    if(_onReset != null)
    {
      _onReset();
    }
  }

  ///Pass the selection event to [IRideDayScheduler].
  bool onDayPressed() => scheduler.onDayPressed(date);

  ///Check if the current date has a ride planned.
  bool hasRidePlanned() => scheduler.hasRidePlanned(date);

  ///Check if the current date is part of the new selection.
  bool isNewlyScheduledRide() => scheduler.isNewlyScheduledRide(date);
}

///This interface represents a contract for checking a ride's date against a schedule of existing dates.
abstract class IRideDayScheduler {
  bool hasRidePlanned(DateTime date);

  bool isNewlyScheduledRide(DateTime date);

  bool onDayPressed(DateTime date);
}