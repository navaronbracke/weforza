import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

///This Bloc will load the rides.
class RideListBloc extends Bloc {
  RideListBloc(this._repository);

  final RideRepository _repository;

  Future<List<Ride>>? ridesFuture;

  void loadRidesIfNotLoaded() {
    ridesFuture ??= _loadRides();
  }

  void reloadRides() {
    ridesFuture = _loadRides();
  }

  Future<List<Ride>> _loadRides() => _repository.getRides();

  Future<int> getAmountOfRideAttendees(DateTime rideDate) =>
      _repository.getAmountOfRideAttendees(rideDate);

  @override
  void dispose() {}
}
