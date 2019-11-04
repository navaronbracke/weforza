
import 'dart:io';

import 'package:weforza/blocs/rideListAttendeeItemBloc.dart';

///This class represents a Ride Attendee wrapped with selection information.
class RideAttendeeItemModel {
  RideAttendeeItemModel(this.bloc,this.image): assert(bloc != null);

  final RideListAttendeeItemBloc bloc;

  final File image;
}