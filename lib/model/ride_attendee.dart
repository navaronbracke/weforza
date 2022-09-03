/// This class represents a [Member] that attends a given [Ride].
class RideAttendee {
  RideAttendee({
    required this.isScanned,
    required this.rideDate,
    required this.uuid,
  }) : assert(uuid.isNotEmpty);

  /// Create a new ride attendee from the given [values].
  factory RideAttendee.of(Map<String, dynamic> values) {
    return RideAttendee(
      // The rate of automatic scanning is bigger than manual selection.
      // Thus we use an 'optimistic' true as default.
      isScanned: values['isScanned'] ?? true,
      rideDate: DateTime.parse(values['date']),
      uuid: values['attendee'],
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

  Map<String, dynamic> toMap() {
    return {
      'attendee': uuid,
      'date': rideDate.toIso8601String(),
      'isScanned': isScanned,
    };
  }

  @override
  int get hashCode => Object.hash(rideDate, uuid, isScanned);

  @override
  bool operator ==(other) {
    return other is RideAttendee &&
        rideDate == other.rideDate &&
        uuid == other.uuid &&
        isScanned == other.isScanned;
  }
}
