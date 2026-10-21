/// @docImport 'package:weforza/database/database.dart';
library;

/// This class represents a `RideAttendee` that was found during a device scan.
///
/// This class implements equality
/// by comparing only the [id]s of two [ScannedRideAttendee]s.
///
/// The [isScanned] attribute is only used for presentation purposes
/// and can thus be eliminated from the equality.
class ScannedRideAttendee {
  const ScannedRideAttendee({required this.id, required this.isScanned});

  factory ScannedRideAttendee.of(Map<String, Object?> values) {
    return ScannedRideAttendee(
      id: values['attendee'] as int,
      // The rate of automatic scanning is bigger than manual selection.
      // Thus we use an 'optimistic' true as default.
      isScanned: values['isScanned'] as bool? ?? true,
    );
  }

  /// The [Rider.id] of the scanned attendee.
  final int id;

  /// Whether the attendee was found automatically in a scan.
  ///
  /// If this is false, the attendee was manually selected.
  final bool isScanned;

  @override
  bool operator ==(Object other) {
    return other is ScannedRideAttendee && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
