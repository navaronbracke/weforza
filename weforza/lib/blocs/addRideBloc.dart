
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideCalendarEvent.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc {
  AddRideBloc(this._repository){
    assert(_repository != null);
    onDayPressed = (date){
      //This date is in the past
      DateTime today = DateTime.now();
      if(date.isBefore(today)) return false;

      //There is a ride with this date.
      if(_existingRides.contains(date)) return false;

      //This is a selected ride, unselect it.
      if(_markedDates.events.containsKey(date)){
        _markedDates.events.remove(date);
        _ridesToAdd.removeWhere((element)=> element.date == date);
        return true;
      }else{
        //Add a new ride.
        final ride = Ride(date,List());
        _ridesToAdd.add(ride);
        _markedDates.add(date, RideCalendarEvent(ride));
        return true;
      }
    };
  }

  ///The repository that will handle the submit.
  final IRideRepository _repository;

  ///The already persistent rides.
  List<DateTime> _existingRides;

  ///The rides to add on a submit.
  List<Ride> _ridesToAdd = List();

  ///The marked dates.
  EventList<RideCalendarEvent> _markedDates = EventList();

  ///The selected date.
  DateTime selectedDate;

  ///The error message, if applicable.
  String errorMessage = "";

  EventList<RideCalendarEvent> get markedDates => _markedDates;

  ///A callback function for when a date is pressed.
  bool Function(DateTime date) onDayPressed;

  ///Load the existing rides.
  Future loadRides() async {
    List<Ride> list = await _repository.getAllRides();
    _markedDates.clear();
    //Add all existing rides to marked dates
    list.forEach((ride) => _markedDates.add(ride.date, RideCalendarEvent(ride)));
    ///Update existing rides
    _existingRides = List.of(_markedDates.events.keys);
  }

  ///Whether a day, has or had a ride planned beforehand.
  bool dayHasRidePlanned(DateTime date){
    assert(date != null);
    return _existingRides.contains(date);
  }

  ///Whether a ride that is now selected, is a new to-be-scheduled ride.
  bool dayIsNewlyScheduledRide(DateTime date) => _markedDates.events.keys.contains(date) && !_existingRides.contains(date);


  ///Dispose of this object.
  @override
  void dispose() {}

  ///Validate if the selection is valid.
  bool validateInputs(String selectionEmptyMessage){
    if(_ridesToAdd.isEmpty){
      errorMessage = selectionEmptyMessage;
      return false;
    }
    else{
      errorMessage = "";
      return true;
    }
  }

  ///Add the selected rides.
  Future addRides() async {
    if(_ridesToAdd.isNotEmpty){
      await _repository.addRides(_ridesToAdd);
    }
  }
}