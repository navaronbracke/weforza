
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

///This Bloc will load the rides.
class RideListBloc extends Bloc {
  RideListBloc(this._repository): assert(_repository != null);

  final RideRepository _repository;

  Future<List<Ride>> loadRides() => _repository.getRides();

  @override
  void dispose() {}
}