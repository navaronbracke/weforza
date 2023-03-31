import 'package:flutter/widgets.dart' show hashValues;

///This class represents an intermediary table that connects [Ride] with [Member].
class RideAttendee {
  RideAttendee({
    required this.rideDate,
    required this.uuid,
    required this.isScanned,
  }): assert(uuid.isNotEmpty);

  ///The date of the ride that belongs to this record.
  final DateTime rideDate;
  ///The GUID of the attendee that belongs to this record.
  final String uuid;
  /// Whether the attendee was scanned or found manually.
  final bool isScanned;

  static RideAttendee of(Map<String,dynamic> values){
    return RideAttendee(
      rideDate: DateTime.parse(values["date"]),
      uuid: values["attendee"],
      // The rate of automatic scanning is bigger than manual selection.
      // Thus we use an 'optimistic' true as default
      isScanned: values["isScanned"] ?? true,
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "date": rideDate.toIso8601String(),
      "attendee": uuid,
      "isScanned": isScanned,
    };
  }

  @override
  int get hashCode => hashValues(rideDate, uuid, isScanned);

  @override
  bool operator ==(other) {
    return other is RideAttendee
        && rideDate == other.rideDate
        && uuid == other.uuid
        && isScanned == other.isScanned;
  }
}