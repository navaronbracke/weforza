
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/rideCalendarEvent.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc {
  AddRideBloc(this._repository) : assert(_repository != null);

  ///The repository that will handle the submit.
  final IRideRepository _repository;

  ///The marked dates.
  EventList<RideCalendarEvent> _markedDates;

  ///The selected date.
  DateTime selectedDate;

  ///Whether the current selection is erroneous.
  bool isError = false;

  ///The error message, if applicable.
  String errorMessage = "";

  EventList<RideCalendarEvent> get markedDates => _markedDates;

  ///A callback function for when a date is pressed.
  Function(DateTime date) _onDayPressed = (date){
    //TODO
  };

  ///Get the callback
  Function(DateTime date) get onDayPressed => _onDayPressed;

  ///Dispose of this object.
  @override
  void dispose() {}

  //TODO submit
}