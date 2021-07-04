
import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/addRidesOrError.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc {
  AddRideBloc({
    required this.repository
  });

  ///The repository that will handle the submit.
  final RideRepository repository;

  late PageController pageController;
  //12 months in a year 300 years range either way.
  final int calendarItemCount = 7200;

  //We start in the middle
  int _currentPage = 3600;

  final StreamController<AddRidesOrError> _submitController = BehaviorSubject();
  Stream<AddRidesOrError> get submitStream => _submitController.stream;

  final StreamController<DateTime> _calendarHeaderController = BehaviorSubject();
  Stream<DateTime> get headerStream => _calendarHeaderController.stream;

  final StreamController<bool> _showDeleteSelectionController = BehaviorSubject();
  Stream<bool> get showDeleteSelectionStream => _showDeleteSelectionController.stream;

  ///The date for the currently visible month in the calendar.
  late DateTime pageDate;

  final Duration _pageDuration = Duration(milliseconds: 300);
  final Curve _pageCurve = Curves.easeInOut;

  //The current submit state is cached, so we can check if we can allow events to alter the selected dates.
  late AddRidesOrError _currentSubmitState;

  ///The days in the month of [pageDate].
  int daysInMonth = 0;

  ///The already persistent rides.
  HashSet<DateTime>? _existingRides;

  ///This future holds the loading process for initializing [_existingRides].
  Future<void>? loadExistingRidesFuture;

  ///The rides to add on a submit.
  HashSet<DateTime> _ridesToAdd = HashSet();

  final List<VoidCallback> _resetFunctions = [];

  //Intercept a day pressed event.
  //Returns true if the item state should be refreshed.
  bool onDayPressed(DateTime date){
    // If we are not saving, continue.
    // At this point we have one of the following:
    // - idle with no warnings
    // - idle with empty selection warning
    if(!_currentSubmitState.saving){
      //if we had a no selection error, clear it.
      if(_currentSubmitState.noSelection){
        _currentSubmitState = AddRidesOrError.idle();
        _submitController.add(_currentSubmitState);
      }

      //There is a ride with this date.
      if(_existingRides!.contains(date)){
        return false;
      }

      //This is a selected ride, unselect it.
      if(_ridesToAdd.contains(date)){
        _ridesToAdd.remove(date);
      }else{
        _ridesToAdd.add(date);
      }
      _showDeleteSelectionController.add(_ridesToAdd.isNotEmpty);

      return true;
    }

    return false;
  }
  
  ///This function clears the current ride dates selection.
  void onClearSelection(){
    // Only clear it when we are not saving.
    // Secondly, clearing it when the empty selection warning is shown, is pointless.
    if(!_currentSubmitState.saving && !_currentSubmitState.noSelection){
      _ridesToAdd.clear();
      _resetFunctions.forEach((method) => method());
      _showDeleteSelectionController.add(false);

      //unset the error -> the submit widget will show an empty string with IDLE
      _currentSubmitState = AddRidesOrError.idle();
      _submitController.add(_currentSubmitState);
    }
  }

  void registerResetFunction(VoidCallback function) => _resetFunctions.add(function);

  void unregisterResetFunction(VoidCallback function)=> _resetFunctions.remove(function);

  ///Load [_existingRides] if not initialized.
  ///This also populates loadExistingRidesFuture, which is used for the calendar.
  void loadRideDatesIfNotLoaded(){
    if(_existingRides == null){
      loadExistingRidesFuture = loadRideDates();
    }
  }

  ///Load the existing ride dates.
  Future<void> loadRideDates() async {
    _existingRides = HashSet.of(await repository.getRideDates());
  }

  ///Whether a day, has or had a ride planned beforehand.
  bool rideScheduledOn(DateTime date){
    return _existingRides!.contains(date) || _ridesToAdd.contains(date);
  }

  ///Whether a ride that is now selected, is a new to-be-scheduled ride.
  ///Rides that were planned previously, but still have to happen aren't 'new' scheduled rides.
  bool rideScheduledDuringCurrentSession(DateTime date){
    return !_existingRides!.contains(date) && _ridesToAdd.contains(date);
  }

  ///Initialize the calendar date.
  void initCalendarDate(){
    final today = DateTime.now();
    final jiffyDate = Jiffy([today.year,today.month,1]);
    pageDate = jiffyDate.dateTime;
    daysInMonth = jiffyDate.daysInMonth;
    pageController = PageController(initialPage: _currentPage);
    _calendarHeaderController.add(pageDate);
    _currentSubmitState = AddRidesOrError.idle();
  }

  ///Add a month to [pageDate].
  void _addMonth(){
    //Always take first day of month as reference
    final newDate = Jiffy([pageDate.year,pageDate.month,1])
      ..add(months: 1);
    pageDate = newDate.dateTime;
    daysInMonth = newDate.daysInMonth;
    _currentPage++;
    _calendarHeaderController.add(pageDate);
  }

  ///Subtract a month from [pageDate].
  void _subtractMonth(){
    //Always take first day of month as reference
    final newDate = Jiffy([pageDate.year,pageDate.month,1])
      ..subtract(months: 1);
    pageDate = newDate.dateTime;
    daysInMonth = newDate.daysInMonth;
    _currentPage--;
    _calendarHeaderController.add(pageDate);
  }

  ///This method handles pressing forward in the header.
  void onPageForward(){
    _addMonth();
    pageController.nextPage(duration: _pageDuration, curve: _pageCurve);
  }

  ///This method handles pressing backward in the header.
  void onPageBackward(){
    _subtractMonth();
    pageController.previousPage(duration: _pageDuration, curve: _pageCurve);
  }

  ///This method handles swiping the calendar.
  void onDragCalendar(DragEndDetails details){
    if(details.velocity.pixelsPerSecond.dx < 0){
      onPageForward();
    }else if(details.velocity.pixelsPerSecond.dx > 0){
      onPageBackward();
    }
  }

  ///Add the selected rides.
  Future<void> addRides() async {
    _currentSubmitState = AddRidesOrError.saving();
    _submitController.add(_currentSubmitState);
    if(_ridesToAdd.isNotEmpty){
      await repository.addRides(_ridesToAdd.map((date) => Ride(date: date)).toList());
    }else{
      //empty selection
      _currentSubmitState = AddRidesOrError.noSelection();
      return Future.error(_currentSubmitState);
    }
  }
  
  void onError(Object error) => _submitController.addError(error);

  ///Whether [date] is before today.
  bool isBeforeToday(DateTime date){
    DateTime today = DateTime.now();
    return date.isBefore(DateTime(today.year,today.month,today.day));
  }

  @override
  int get hashCode {
    final setEquality = SetEquality();
    return hashValues(pageDate, _currentSubmitState, setEquality.hash(_existingRides), setEquality.hash(_ridesToAdd));
  }

  @override
  bool operator ==(Object other){
    final setEquality = SetEquality();
    return other is AddRideBloc && pageDate == other.pageDate
        && _currentSubmitState == other._currentSubmitState
        && setEquality.equals(_ridesToAdd, other._ridesToAdd)
        && setEquality.equals(_existingRides, other._existingRides);
  }
  
  @override
  void dispose() {
    _resetFunctions.clear();
    _submitController.close();
    _calendarHeaderController.close();
    _showDeleteSelectionController.close();
    pageController.dispose();
  }
}