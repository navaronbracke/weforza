
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

class EditRideBloc extends Bloc {
  EditRideBloc({@required this.repository, @required this.ride}):
        assert(repository != null && ride != null)
  {
    titleInput = ride.title ?? "";
    distanceInput = ride.distance;
    departureInput = ride.startAddress ?? "";
    destinationInput = ride.destinationAddress ?? "";
  }

  final StreamController<EditRideSubmitState> _submitController = BehaviorSubject();
  Stream<EditRideSubmitState> get stream => _submitController.stream;

  final Ride ride;
  final RideRepository repository;

  final int maxDistanceInKm = 300;
  final int addressMaxLength = 80;

  ///The actual inputs
  String titleInput;
  double distanceInput;
  String departureInput;
  String destinationInput;

  ///The input errors
  String titleError;
  String distanceError;
  String departureError;
  String destinationError;

  ///Auto validation flags per input.
  ///Validation should start once an input came into focus at least once.
  bool autoValidateTitle = false;
  bool autoValidateDistance = false;
  bool autoValidateDepartureAddress = false;
  bool autoValidateDestinationAddress = false;

  ///Validate the title input.
  String validateTitle(String value,String isWhitespaceMessage, String maxLengthMessage){
    //Title is empty, return since we can stop validating.
    if(value == null || value.isEmpty){
      titleInput = null;
      titleError = null;
    }else{
      //Whitespace
      if(value.trim().isEmpty){
        titleError = isWhitespaceMessage;
      }else if(value.length > Ride.titleMaxLength){
        //Max Length
        titleError = maxLengthMessage;
      }else {
        titleError = null;
        titleInput = value;
      }
    }
    return titleError;
  }

  //Validate the distance input.
  String validateDistance(String value, String invalidDistanceMessage, String positiveDistanceRequiredMessage, String maximumDistanceMessage){
    //Distance is empty, return since we can stop validating.
    if(value == null || value.isEmpty){
      distanceInput = 0.0;
      distanceError = null;
    }else{
      value = Ride.convertNumberSeparator(value, oldSeparator: ",", newSeparator: ".");
      double distance = double.tryParse(value);
      if(distance == null){
        distanceError = invalidDistanceMessage;
      }else{
        if(distance <= 0){
          distanceError = positiveDistanceRequiredMessage;
        }else if(distance > maxDistanceInKm){
          distanceError = maximumDistanceMessage;
        }else {
          distanceInput = distance;
          distanceError = null;
        }
      }
    }
    return distanceError;
  }

  //Validate the departure input.
  String validateDepartureAddress(String value,String isWhitespaceMessage,String maxLengthMessage,String invalidAddressMessage){
    if(value == null || value.isEmpty){
      departureInput = null;
      departureError = null;
    }else{
      if(value.trim().isEmpty){
        departureError = isWhitespaceMessage;
      }else if(value.length > addressMaxLength){
        departureError = maxLengthMessage;
      }else if(Ride.addressRegex.hasMatch(value)){
        departureError = null;
        departureInput = value;
      }else{
        departureError = invalidAddressMessage;
      }
    }
    return departureError;
  }

  //Validate the destination input.
  String validateDestinationAddress(String value,String isWhitespaceMessage,String maxLengthMessage,String invalidAddressMessage){
    if(value == null || value.isEmpty){
      destinationInput = null;
      destinationError = null;
    }else{
      if(value.trim().isEmpty){
        destinationError = isWhitespaceMessage;
      }else if(value.length > addressMaxLength){
        destinationError = maxLengthMessage;
      }else if(Ride.addressRegex.hasMatch(value)){
        destinationError = null;
        destinationInput = value;
      }else {
        destinationError = invalidAddressMessage;
      }
    }
    return destinationError;
  }

  ///Edit the ride and return the updated ride.
  Future<Ride> editRide() async {
    _submitController.add(EditRideSubmitState.SUBMIT);
    //Grab a copy first
    final newRide = Ride(
      date: ride.date,
      title: titleInput == "" ? null : titleInput,
      destinationAddress: destinationInput == "" ? null : destinationInput,
      startAddress: departureInput == "" ? null : departureInput,
      distance: distanceInput
    );
    //Save the copy, if it fails, nothing gets overwritten.
    return await repository.editRide(newRide).then((_){
      return newRide;
    },onError: (e){
      _submitController.add(EditRideSubmitState.ERROR);
      return Future.error(EditRideSubmitState.ERROR);
    });
  }

  @override
  void dispose() {
    _submitController.close();
  }
}

enum EditRideSubmitState {
  IDLE,SUBMIT,ERROR
}