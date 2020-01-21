
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/rideRepository.dart';

///This Bloc will load the rides.
class RideListBloc extends Bloc {
  RideListBloc(this._repository): assert(_repository != null);

  final RideRepository _repository;

  ///Internal future that is returned.
  Future<List<Ride>> _ridesFuture;

  ///Load the rides if reload is true.
  ///Return the future afterwards.
  Future<List<Ride>> loadRides(){
    if(RideProvider.reloadRides){
      _ridesFuture = _repository.getRides();
    }
    return _ridesFuture;
  }

  @override
  void dispose() {}
}