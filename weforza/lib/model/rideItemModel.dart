
import 'package:weforza/blocs/rideListRideItemBloc.dart';

///This class represents a Ride wrapped with selection information.
class RideItemModel {
  RideItemModel(this.bloc): assert(bloc != null);

  final RideListRideItemBloc bloc;
}