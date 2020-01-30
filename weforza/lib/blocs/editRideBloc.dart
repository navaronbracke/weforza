
import 'dart:async';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

class EditRideBloc extends Bloc {
  EditRideBloc(this._repository): assert(_repository != null);

  final RideRepository _repository;

  ///Max values for input
  final int titleMaxLength = 80;
  final int maxDistanceInKm = 300;
  final int departureMaxLength = 80;
  final int destinationMaxLength = 80;

  ///The actual inputs
  String _titleInput;
  double _distanceInput;
  String _departureInput;
  String _destinationInput;

  ///The input errors
  String titleError;
  String distanceError;
  String departureError;
  String destinationError;

  ///Auto validation flags per input.
  ///Validation should start once an input came into focus at least once.
  bool autoValidateTitle = false;
  bool autoValidateDistance = false;
  bool autoValidateStartAddress = false;
  bool autoValidateDestinationAddress = false;

  ///Validate the title input.
  String validateTitle(String value,String isWhitespaceMessage, String maxLengthMessage){
    //Title is empty, return since we can stop validating.
    if(value == null || value.isEmpty){
      _titleInput = null;
      titleError = null;
    }else{
      //Whitespace
      if(value.trim().isEmpty){
        titleError = isWhitespaceMessage;
      }else if(value.length > titleMaxLength){
        //Max Length
        titleError = maxLengthMessage;
      }else if(value != _titleInput){
        titleError = null;
        _titleInput = value;
      }
    }
    return titleError;
  }

  //Validate the distance input.
  String validateDistance(String value, String invalidDistanceMessage, String positiveDistanceRequiredMessage, String maximumDistanceMessage){
    //Distance is empty, return since we can stop validating.
    if(value == null || value.isEmpty){
      _distanceInput = 0.0;
      distanceError = null;
    }else{
      double distance = double.tryParse(value);
      if(distance == null){
        distanceError = invalidDistanceMessage;
      }else{
        if(distance <= 0){
          distanceError = positiveDistanceRequiredMessage;
        }else if(distance > maxDistanceInKm){
          distanceError = maximumDistanceMessage;
        }else if(distance != _distanceInput){
          _distanceInput = distance;
          distanceError = null;
        }
      }
    }
    return distanceError;
  }

  //Validate the departure input.
  String validateDepartureAddress(String value,String isWhitespaceMessage,String maxLengthMessage,String invalidAddressMessage){
    if(value == null || value.isEmpty){
      _departureInput = null;
      departureError = null;
    }else{
      if(value.trim().isEmpty){
        departureError = isWhitespaceMessage;
      }else if(value.length > departureMaxLength){
        departureError = maxLengthMessage;
      }else if(!Ride.addressRegex.hasMatch(value)){
        departureError = invalidAddressMessage;
      }else if(value != _departureInput){
        departureError = null;
        _departureInput = value;
      }
    }
    return departureError;
  }

  //Validate the destination input.
  String validateDestinationAddress(String value,String isWhitespaceMessage,String maxLengthMessage,String invalidAddressMessage){
    if(value == null || value.isEmpty){
      _destinationInput = null;
      destinationError = null;
    }else{
      if(value.trim().isEmpty){
        destinationError = isWhitespaceMessage;
      }else if(value.length > destinationMaxLength){
        destinationError = maxLengthMessage;
      }else if(!Ride.addressRegex.hasMatch(value)){
        destinationError = invalidAddressMessage;
      }else if(value != _destinationInput){
        destinationError = null;
        _destinationInput = value;
      }
    }
    return destinationError;
  }

  Future<void> editRide(Ride ride) async {
    ride.title = _titleInput;
    ride.distance = _distanceInput;
    ride.startAddress = _departureInput;
    ride.destinationAddress = _destinationInput;
    await _repository.editRide(ride);
  }

  @override
  void dispose() {}
}