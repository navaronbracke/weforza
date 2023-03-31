import 'package:flutter/widgets.dart';

///This class represents an intermediary table that connects [Ride] with [Member].
class RideAttendee {
  RideAttendee(this.rideDate,this.attendeeId): assert(attendeeId.isNotEmpty);

  ///The date of the ride that belongs to this record.
  final DateTime rideDate;
  ///The GUID of the attendee that belongs to this record.
  final String attendeeId;

  static RideAttendee of(Map<String,dynamic> values){
    return RideAttendee(DateTime.parse(values["date"]),values["attendee"]);
  }

  Map<String,dynamic> toMap(){
    return {
      "date": rideDate.toIso8601String(),
      "attendee": attendeeId
    };
  }

  @override
  int get hashCode => hashValues(rideDate, attendeeId);

  @override
  bool operator ==(other) {
    return other is RideAttendee &&
        rideDate == other.rideDate && attendeeId == other.attendeeId;
  }
}