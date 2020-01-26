import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';

///This interface defines a contract for selecting/unselecting ride attendees.
abstract class RideAttendeeSelector {
  void select(RideAttendeeAssignmentItemBloc item);

  void unSelect(RideAttendeeAssignmentItemBloc item);
}