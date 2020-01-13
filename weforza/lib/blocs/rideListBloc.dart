
import 'dart:async';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

///This is the BLoC for RideListPage.
class RideListBloc extends Bloc {
  RideListBloc(this._rideRepository): assert(_rideRepository != null);

  ///The [IRideRepository] that will manage the Rides section of RideListPage.
  final RideRepository _rideRepository;

  ///Load the rides from the database.
  Future<List<Ride>> getRides() async => await _rideRepository.getRides();

  @override
  void dispose() {}
}

