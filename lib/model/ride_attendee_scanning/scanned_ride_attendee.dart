/// This class represents a `RideAttendee` that was found during a device scan.
///
/// This class implements equality
/// by comparing only the [uuid]s of two [ScannedRideAttendee]s.
///
/// The [isScanned] attribute is only used for presentation purposes
/// and can thus be eliminated from the equality.
class ScannedRideAttendee {
  const ScannedRideAttendee({required this.uuid, required this.isScanned});

  factory ScannedRideAttendee.of(Map<String, Object?> values) {
    return ScannedRideAttendee(
      uuid: values['attendee'] as String,
      // The rate of automatic scanning is bigger than manual selection.
      // Thus we use an 'optimistic' true as default.
      isScanned: values['isScanned'] as bool? ?? true,
    );
  }

  /// The UUID of the scanned attendee.
  final String uuid;

  /// Whether the attendee was found automatically in a scan.
  ///
  /// If this is false, the attendee was manually selected.
  final bool isScanned;

  @override
  bool operator ==(Object other) {
    return other is ScannedRideAttendee && uuid == other.uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}
