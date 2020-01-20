
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

class RideProvider {
  RideProvider(this._repository): assert(_repository != null);

  final RideRepository _repository;

  Ride selectedRide;

  Future<List<Ride>> ridesFuture;

  void loadRidesIfNotLoaded(){
    if(ridesFuture == null){
      loadRides();
    }
  }

  void loadRides(){
    ridesFuture = _repository.getRides();
  }
}