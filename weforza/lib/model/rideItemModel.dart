
import 'package:weforza/blocs/rideListRideItemBloc.dart';
import 'package:weforza/model/ride.dart';

///This class represents a Ride wrapped with selection information.
class RideItemModel {
  RideItemModel(this.bloc): assert(bloc != null);

  final RideListRideItemBloc bloc;

  bool isAttendeeOfRide(Attendee attendee) => bloc.isAttendee(attendee);
}