
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc {
  AddRideBloc(this._repository){
    assert(_repository != null);
    onDayPressed = (date){
      DateTime today = DateTime.now();
      //This date is in the past OR there is a ride with this date.
      if(date.isBefore(DateTime(today.year,today.month,today.day)) || _existingRides.contains(date)) return false;

      //This is a selected ride, unselect it.
      if(_ridesToAdd.contains(date)){
        _ridesToAdd.remove(date);
        _errorMessageController.add("");
        return true;
      }else{
        _ridesToAdd.add(date);
        _errorMessageController.add("");
        return true;
      }
    };
  }

  ///The repository that will handle the submit.
  final IRideRepository _repository;

  ///The date for the currently visible month in the calendar.
  DateTime pageDate;

  ///The days in the month of [pageDate].
  int daysInMonth = 0;

  ///The already persistent rides.
  List<DateTime> _existingRides;

  ///The rides to add on a submit.
  List<DateTime> _ridesToAdd = List();

  ///The [StreamController] for the error message.
  StreamController<String> _errorMessageController = BehaviorSubject();
  ///Get the error message stream.
  Stream<String> get stream => _errorMessageController.stream;
  ///Add [message] to the stream.
  void addErrorMessage(String message) => _errorMessageController.add(message);

  ///A callback function for when a date is pressed.
  bool Function(DateTime date) onDayPressed;

  ///A callback function that is fired when a selection clear is requested.
  VoidCallback _onSelectionCleared;

  set onSelectionCleared(VoidCallback function) => _onSelectionCleared = function;

  ///This function clears the current ride dates selection.
  void onRequestClear(){
    if(_ridesToAdd.isNotEmpty && _onSelectionCleared != null){
      _onSelectionCleared();
      _ridesToAdd.clear();
      _errorMessageController.add("");
    }
  }

  ///Load the existing rides.
  Future loadRides() async {
    List<Ride> data = await _repository.getAllRides();
    _existingRides = data.map((ride) => ride.date).toList();
  }

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

  ///Validate if the selection is valid.
  bool validateInputs() => _ridesToAdd.isEmpty ? false : true;

  ///Add the selected rides.
  Future<bool> addRides() async {
    bool result = false;
    if(_ridesToAdd.isNotEmpty){
      await _repository.addRides(_ridesToAdd.map((date) => Ride(date,List())).toList()).then((_){
        _errorMessageController.add("");
        result = true;
      },onError: (error){
        _errorMessageController.addError(Exception("Failed to add rides"));
      });
    }
    return result;
  }

  ///Dispose of this object.
  @override
  void dispose() {
    _errorMessageController.close();
  }
}