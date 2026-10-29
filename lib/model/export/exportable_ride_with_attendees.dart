import 'package:collection/collection.dart';
import 'package:weforza/model/export/exportable_ride.dart';
import 'package:weforza/model/export/exportable_ride_attendee.dart';

final class ExportableRideWithAttendees {
  const new({required this.attendees, required this.ride});

  /// The attendees of the ride to export.
  final Iterable<ExportableRideAttendee> attendees;

  /// The ride to export.
  final ExportableRide ride;

  /// Convert this object into an exportable comma separated value string.
  void toCsv(StringBuffer buffer) {
    buffer.writeln(ride.toCsv());
    for (final attendee in attendees) {
      buffer.writeln(attendee.toCsv());
    }
  }

  /// Convert this object into an exportable JSON object.
  Map<String, Object?> toJson() {
    return {
      'ride': ride.toJson(),
      'attendees': [for (final attendee in attendees) attendee.toJson()],
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! ExportableRideWithAttendees) {
      return false;
    }

    return ride == other.ride && const IterableEquality<ExportableRideAttendee>().equals(attendees, other.attendees);
  }

  @override
  int get hashCode => Object.hash(ride, const IterableEquality<ExportableRideAttendee>().hash(attendees));
}
