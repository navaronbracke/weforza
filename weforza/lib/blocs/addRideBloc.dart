
import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

///The on item reset callback signature.
typedef OnReset = void Function();

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc {
  AddRideBloc({@required this.repository}): assert(repository != null);

  ///The repository that will handle the submit.
  final RideRepository repository;

  PageController pageController;
  //12 months in a year 3000 years range either way.
  final int calendarItemCount = 72000;

  //We start in the middle
  int currentPage = 36000;

  final StreamController<AddRideSubmitState> _submitController = BehaviorSubject();
  Stream<AddRideSubmitState> get submitStream => _submitController.stream;

  final StreamController<DateTime> _calendarHeaderController = BehaviorSubject();
  Stream<DateTime> get headerStream => _calendarHeaderController.stream;

  ///The date for the currently visible month in the calendar.
  DateTime pageDate;

  final Duration _pageDuration = Duration(milliseconds: 300);
  final Curve _pageCurve = Curves.easeInOut;

  //The current submit state is cached, so we can check if we can allow events to alter the selected dates.
  AddRideSubmitState _currentSubmitState;

  ///The days in the month of [pageDate].
  int daysInMonth = 0;

  ///The already persistent rides.
  HashSet<DateTime> _existingRides;

  ///This future holds the loading process for initializing [_existingRides].
  Future<void> loadExistingRidesFuture;

  ///The rides to add on a submit.
  HashSet<DateTime> _ridesToAdd = HashSet();

  final List<OnReset> resetCallbacks = List();

  //Intercept a day pressed event.
  //Returns true if the item state should be refreshed.
  bool onDayPressed(DateTime date){
    if(_currentSubmitState != AddRideSubmitState.IDLE) return false;

    //This date is in the past OR there is a ride with this date.
    if(isBeforeToday(date) || _existingRides.contains(date)){
      return false;
    }

    //This is a selected ride, unselect it.
    if(_ridesToAdd.contains(date)){
      _ridesToAdd.remove(date);
    }else{
      _ridesToAdd.add(date);
    }
    return true;
  }
  
  ///This function clears the current ride dates selection.
  void onRequestClear(){
    if(_currentSubmitState == AddRideSubmitState.IDLE && _ridesToAdd.isNotEmpty){
      _ridesToAdd.clear();
      //Notify all items to reset themselves.
      resetCallbacks.forEach((onReset) => onReset());
    }
  }

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
  bool dayHasRidePlanned(DateTime date){
    assert(date != null);
    return _existingRides.contains(date) || _ridesToAdd.contains(date);
  }

  ///Whether a ride that is now selected, is a new to-be-scheduled ride.
  ///Rides that were planned previously, but still have to happen aren't 'new' scheduled rides.
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
    pageController = PageController(initialPage: currentPage);
    _calendarHeaderController.add(pageDate);
  }

  bool _canGoForward() => currentPage + 1 <= calendarItemCount - 1;

  bool _canGoBackward() => currentPage - 1 >= 0;

  //The header wants to go one month forward.
  //Update the header and let the pageview go forward.
  void onHeaderForward(){
    if(_canGoForward()){
      _addMonth();
      _calendarHeaderController.add(pageDate);
      pageController.nextPage(duration: _pageDuration, curve: _pageCurve);
    }
  }

  //The header wants to go one month backward.
  //Update the header and let the pageview go backward.
  void onHeaderBackward(){
    if(_canGoBackward()){
      _subtractMonth();
      _calendarHeaderController.add(pageDate);
      pageController.nextPage(duration: _pageDuration, curve: _pageCurve);
    }
  }

  //The pageview wants to go forward.
  //Update the header. The pageview will update by itself.
  //The pageview doesn't go beyond it's item count or under zero,
  //thus we don't need to check the bounds.
  void onPageViewForward(){
    _addMonth();
    _calendarHeaderController.add(pageDate);
  }

  //The pageview wants to go backward.
  //Update the header. The pageview will update by itself.
  //The pageview doesn't go beyond it's item count or under zero,
  //thus we don't need to check the bounds.
  void onPageViewBackward(){
    _subtractMonth();
    _calendarHeaderController.add(pageDate);
  }

  ///Add a month to [pageDate].
  void _addMonth(){
    //Prevent months changing when we are sumbitting
    if(_currentSubmitState == AddRideSubmitState.IDLE){
      //Always take first day of month as reference
      final newDate = Jiffy([pageDate.year,pageDate.month,1])
        ..add(months: 1);
      pageDate = newDate.dateTime;
      daysInMonth = newDate.daysInMonth;
      currentPage++;
      resetCallbacks.clear();//Remove the old callbacks
    }
  }

  ///Subtract a month from [pageDate].
  void _subtractMonth(){
    //Prevent months changing when we are sumbitting
    if(_currentSubmitState == AddRideSubmitState.IDLE){
      //Always take first day of month as reference
      final newDate = Jiffy([pageDate.year,pageDate.month,1])
        ..subtract(months: 1);
      pageDate = newDate.dateTime;
      daysInMonth = newDate.daysInMonth;
      currentPage--;
      resetCallbacks.clear();//Remove the old callbacks
    }
  }

  ///Add the selected rides.
  Future<void> addRides() async {
    if(_currentSubmitState != AddRideSubmitState.SUBMIT){
      _currentSubmitState = AddRideSubmitState.SUBMIT;
      _submitController.add(_currentSubmitState);
      if(_ridesToAdd.isNotEmpty){
        await repository.addRides(_ridesToAdd.map((date) => Ride(date: date)).toList()).catchError((error){
          _currentSubmitState = AddRideSubmitState.ERR_SUBMIT;
          _submitController.add(_currentSubmitState);
          return Future.error(_currentSubmitState);
        });
      }else{
        //empty selection
        _currentSubmitState = AddRideSubmitState.ERR_NO_SELECTION;
        _submitController.add(_currentSubmitState);
        return Future.error(_currentSubmitState);
      }
    }
  }

  ///Whether [date] is before today.
  bool isBeforeToday(DateTime date){
    DateTime today = DateTime.now();
    return date.isBefore(DateTime(today.year,today.month,today.day));
  }

  ///Register an item's reset function.
  ///Each registered item will be reset when we call onRequestClear.
  void registerResetCallback(OnReset callback) => resetCallbacks.add(callback);

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
    _submitController.close();
    _calendarHeaderController.close();
  }

  void onPageChanged(int page) => page > pageController.page ? onPageViewForward() : onPageViewBackward();
}

///This enum declares the different states for the ride submit process.
///[AddRideSubmitState.IDLE] There is no submit in progress.
///[AddRideSubmitState.SUBMIT] There is a submit in progress.
///[AddRideSubmitState.ERR_SUBMIT] The rides could not be saved.
///[AddRideSubmitState.ERR_NO_SELECTION] There is no selection to save.
enum AddRideSubmitState {
  IDLE, SUBMIT, ERR_NO_SELECTION, ERR_SUBMIT
}