
import 'package:jiffy/jiffy.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarPaginator.dart';

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc implements IAddRideCalendarPaginator {
  AddRideBloc(this._repository){
    assert(_repository != null);
    onDayPressed = (date){
      //This date is in the past
      if(date.isBefore(DateTime.now())) return false;

      //There is a ride with this date.
      if(_existingRides.contains(date)) return false;

      //This is a selected ride, unselect it.
      if(_ridesToAdd.contains(date)){
        _ridesToAdd.remove(date);
        return true;
      }else{
        _ridesToAdd.add(date);
        return true;
      }
    };
  }

  ///The repository that will handle the submit.
  final IRideRepository _repository;

  ///The date for the currently visible month in the calendar.
  DateTime pageDate;

  ///The already persistent rides.
  List<DateTime> _existingRides;

  ///The rides to add on a submit.
  List<DateTime> _ridesToAdd = List();

  ///The error message, if applicable.
  String errorMessage = "";

  ///A callback function for when a date is pressed.
  bool Function(DateTime date) onDayPressed;

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

  void addMonth(){
    //Always take first day of month as reference
    final newDate = Jiffy([pageDate.year,pageDate.month,1])
      ..add(months: 1);
    pageDate = newDate.dateTime;
  }

  void subtractMonth(){
    //Always take first day of month as reference
    final newDate = Jiffy([pageDate.year,pageDate.month,1])
      ..subtract(months: 1);
    pageDate = newDate.dateTime;
  }


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
      await _repository.addRides(_ridesToAdd.map((date) => Ride(date,List())));
    }
  }

  @override
  void pageBack() => subtractMonth();

  @override
  void pageForward() => addMonth();
}