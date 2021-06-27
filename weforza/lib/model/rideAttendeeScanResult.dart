
/// This class represents a ride attendee as a scan result.
class RideAttendeeScanResult {
  RideAttendeeScanResult({
    required this.uuid,
    required this.isScanned,
  });

  /// The UUID of the scanned member.
  final String uuid;

  /// Whether the ride attendee was found using scanning.
  /// If true, the ride attendee was automatically found, using a device scan.
  /// If false, the ride attendee was found manually.
  /// This can either be through multiple-owner conflict resolution
  /// or manual selection.
  bool isScanned;

  static RideAttendeeScanResult of(Map<String,dynamic> values){
    return RideAttendeeScanResult(
      uuid: values["attendee"],
      // The rate of automatic scanning is bigger than manual selection.
      // Thus we use an 'optimistic' true as default.
      isScanned: values["isScanned"] ?? true,
    );
  }

  /// Two instances of [RideAttendeeScanResult] are equal if their UUID's match.
  /// Whether the attendee was found through a scan or not is irrelevant.
  /// This enables equality checking on the uuid in a [Set].
  @override
  bool operator ==(Object other)
    => other is RideAttendeeScanResult && uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}