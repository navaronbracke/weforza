import 'package:weforza/model/ride.dart';

class ExportableRide {
  ExportableRide({required this.ride, required this.attendees});

  final Iterable<ExportableRideAttendee> attendees;
  final Ride ride;

  void toCsv(StringBuffer buffer) {
    buffer.writeln(ride.toCsv());
    for (final attendee in attendees) {
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
class ExportableRideAttendee implements Comparable<ExportableRideAttendee> {
  ExportableRideAttendee({
    required this.firstName,
    required this.lastName,
    this.alias = '',
  }) : assert(
          firstName.isNotEmpty && lastName.isNotEmpty,
          'The first name and last name of an exportable ride attendee should not be empty',
        );

  final String firstName;
  final String lastName;
  final String alias;

  Map<String, Object> toJson() {
    return {'firstName': firstName, 'lastName': lastName, 'alias': alias};
  }

  String toCsv() {
    return '$firstName,$lastName${alias.isEmpty ? '' : ',$alias'}';
  }

  @override
  int compareTo(ExportableRideAttendee other) {
    final firstNameComparison = firstName.compareTo(other.firstName);

    if (firstNameComparison != 0) {
      return firstNameComparison;
    }

    final lastNameComparison = lastName.compareTo(other.lastName);

    if (lastNameComparison != 0) {
      return lastNameComparison;
    }

    // Both aliases are empty, thus both are equal.
    if (alias.isEmpty && other.alias.isEmpty) {
      return 0;
    }

    // This object has more priority based on its alias.
    if (alias.isNotEmpty && other.alias.isEmpty) {
      return -1;
    }

    // This object has less priority based on its alias.
    if (alias.isEmpty && other.alias.isNotEmpty) {
      return 1;
    }

    // Both have non-empty aliases, compare them.
    return alias.compareTo(other.alias);
  }
}
