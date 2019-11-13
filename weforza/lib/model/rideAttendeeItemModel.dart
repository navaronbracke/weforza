import 'package:weforza/blocs/rideListAttendeeItemBloc.dart';

///This class represents a Ride Attendee wrapped with selection information.
class RideAttendeeItemModel {
  RideAttendeeItemModel(this.bloc): assert(bloc != null);

  final RideListAttendeeItemBloc bloc;
}