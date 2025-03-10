/// @docImport 'package:weforza/model/ride.dart';
/// @docImport 'package:weforza/model/rider/rider.dart';
library;

/// This class represents a [Rider] that attends a given [Ride].
class RideAttendee {
  RideAttendee({required this.isScanned, required this.rideDate, required this.uuid})
    : assert(uuid.isNotEmpty, 'The uuid of a ride attendee should not be empty');

  /// Create a new ride attendee from the given [values].
  factory RideAttendee.of(Map<String, Object?> values) {
    return RideAttendee(
      // The rate of automatic scanning is bigger than manual selection.
      // Thus we use an 'optimistic' true as default.
      isScanned: values['isScanned'] as bool? ?? true,
      rideDate: DateTime.parse(values['date'] as String),
      uuid: values['attendee'] as String,
    );
  }

  /// Whether the attendee was scanned.
  ///
  /// If this is false, the attendee was manually selected.
  final bool isScanned;

  /// The date of the ride that belongs to this record.
  final DateTime rideDate;

  /// The UUID of the attendee that belongs to this record.
  final String uuid;

  Map<String, Object?> toMap() {
    return {'attendee': uuid, 'date': rideDate.toIso8601String(), 'isScanned': isScanned};
  }

  @override
  int get hashCode => Object.hash(rideDate, uuid, isScanned);

  @override
  bool operator ==(Object other) {
    return other is RideAttendee && rideDate == other.rideDate && uuid == other.uuid && isScanned == other.isScanned;
  }
}
