
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc {
  AddRideBloc({@required this.repository}): assert(repository != null);

  ///The repository that will handle the submit.
  final RideRepository repository;

  final StreamController<AddRideSubmitState> _submitController = BehaviorSubject();
  Stream<AddRideSubmitState> get submitStream => _submitController.stream;

  ///The date for the currently visible month in the calendar.
  DateTime pageDate;

  ///The days in the month of [pageDate].
  int daysInMonth = 0;

  ///The already persistent rides.
  List<DateTime> _existingRides;

  ///The rides to add on a submit.
  List<DateTime> _ridesToAdd = List();

  ///A callback function that is fired when a selection clear is requested.
  VoidCallback _onSelectionCleared;

  set onSelectionCleared(VoidCallback function) => _onSelectionCleared = function;

  //Intercept a day pressed event.
  bool onDayPressed(DateTime date){
    DateTime today = DateTime.now();
    //This date is in the past OR there is a ride with this date.
    if(date.isBefore(DateTime(today.year,today.month,today.day)) || _existingRides.contains(date)){
      return false;
    }

    //This is a selected ride, unselect it.
    if(_ridesToAdd.contains(date)){
      _ridesToAdd.remove(date);
      _submitController.add(AddRideSubmitState.IDLE);
      return true;
    }else{
      _ridesToAdd.add(date);
      _submitController.add(AddRideSubmitState.IDLE);
      return true;
    }
  }

  ///This function clears the current ride dates selection.
  void onRequestClear(){
    if(_ridesToAdd.isNotEmpty && _onSelectionCleared != null){
      _onSelectionCleared();
      _ridesToAdd.clear();
      _submitController.add(AddRideSubmitState.IDLE);
    }
  }

  ///Load the existing ride dates.
  Future<List<DateTime>> loadRideDates() async => _existingRides = await repository.getRideDates();

  ///Whether a day, has or had a ride planned beforehand.
  bool dayHasRidePlanned(DateTime date){
    assert(date != null);
    return _existingRides.contains(date) || _ridesToAdd.contains(date);
  }
  
  ///Whether a ride that is now selected, is a new to-be-scheduled ride.
  bool dayIsNewlyScheduledRide(DateTime date){
    assert(date != null);
    return !_existingRides.contains(date) && _ridesToAdd.contains(date);
  }

  ///Initialize the calendar date.
  void initCalendarDate(){
    final today = DateTime.now();
    final jiffyDate = Jiffy([today.year,today.month,1]);
    pageDate = jiffyDate.dateTime;
    daysInMonth = jiffyDate.daysInMonth;
  }

  ///Add a month to [pageDate].
  ///This does not trigger a page switch.
  void addMonth(){
    //Always take first day of month as reference
    final newDate = Jiffy([pageDate.year,pageDate.month,1])
      ..add(months: 1);
    pageDate = newDate.dateTime;
    daysInMonth = newDate.daysInMonth;
  }

  ///Subtract a month from [pageDate].
  ///This does not trigger a page switch.
  void subtractMonth(){
    //Always take first day of month as reference
    final newDate = Jiffy([pageDate.year,pageDate.month,1])
      ..subtract(months: 1);
    pageDate = newDate.dateTime;
    daysInMonth = newDate.daysInMonth;
  }

  ///Add the selected rides.
  Future<void> addRides(VoidCallback onSuccess) async {
    if(_ridesToAdd.isNotEmpty){
      _submitController.add(AddRideSubmitState.SUBMIT);
      await repository.addRides(_ridesToAdd.map((date) => Ride(date: date)).toList()).then((_)
      {
        onSuccess();
      },onError: (error){
        _submitController.add(AddRideSubmitState.ERR_SUBMIT);
      });
    }else{
      _submitController.add(AddRideSubmitState.ERR_NO_SELECTION);
    }
  }

  ///Dispose of this object.
  @override
  void dispose() {
    _submitController.close();
  }
}

///This enum declares the different states for the ride submit process.
///[AddRideSubmitState.IDLE] There is no submit in progress.
///[AddRideSubmitState.SUBMIT] There is a submit in progress.
///[AddRideSubmitState.ERR_SUBMIT] The rides could not be saved.
///[AddRideSubmitState.ERR_NO_SELECTION] There is no selection to save.
enum AddRideSubmitState {
  IDLE, SUBMIT, ERR_NO_SELECTION, ERR_SUBMIT
}