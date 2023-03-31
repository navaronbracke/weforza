import 'package:weforza/model/ride.dart';

class ExportableRide {
  ExportableRide({required this.ride, required this.attendees});

  final Iterable<ExportableRideAttendee> attendees;
  final Ride ride;

  void toCsv(StringBuffer buffer) {
    buffer.writeln(ride.toCsv());
    for (ExportableRideAttendee attendee in attendees) {
      buffer.writeln(attendee.toCsv());
    }
  }

  Map<String, Object?> toJson() {
    return {
      'ride': ride.toJson(),
      'attendees': attendees.map((attendee) => attendee.toJson()).toList(),
    };
  }
}

/// This class represents a RideAttendee in a format that is suitable
/// for exporting inside a [ExportableRide].
class ExportableRideAttendee {
  ExportableRideAttendee({
    required this.firstName,
    required this.lastName,
    this.alias = '',
  }) : assert(firstName.isNotEmpty && lastName.isNotEmpty);

  final String firstName;
  final String lastName;
  final String alias;

  Map<String, Object> toJson() {
    return {'firstName': firstName, 'lastName': lastName, 'alias': alias};
  }

  String toCsv() {
    return '$firstName,$lastName${alias.isEmpty ? '' : ',$alias'}';
  }
}
