
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class represents the BLoC for AddRidePage.
class AddRideBloc extends Bloc {
  AddRideBloc(this._repository) : assert(_repository != null);

  ///The repository that will handle the submit.
  final IRideRepository _repository;

  ///Whether the current selection is erroneous.
  bool isError = false;

  ///The error message, if applicable.
  String errorMessage = "";

  ///Dispose of this object.
  @override
  void dispose() {}

  //TODO submit
}