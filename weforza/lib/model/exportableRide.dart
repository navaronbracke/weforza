
import 'package:flutter/foundation.dart';
import 'package:weforza/model/ride.dart';

class ExportableRide {
  ExportableRide({
    @required this.ride,
    @required this.attendees
  }): assert(ride != null && attendees != null);

  final List<ExportableRideAttendee> attendees;
  final Ride ride;
}

///This class represents a RideAttendee in a format that is suitable for exporting inside a [ExportableRide].
class ExportableRideAttendee {
  ExportableRideAttendee({
    @required this.firstName,
    @required this.lastName,
    this.alias = "",
  }): assert(
    firstName != null && firstName.isNotEmpty
        && lastName != null && lastName.isNotEmpty
  );

  final String firstName;
  final String lastName;
  //Members will have aliases in the future, as a replacement for phone numbers.
  //We add a field for the alias to be future proof.
  final String alias;
}