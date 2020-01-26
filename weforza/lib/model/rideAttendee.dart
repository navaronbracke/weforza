import 'package:weforza/model/ride.dart';

///This class represents an intermediary table that connects [Ride] with [Member].
class RideAttendee {
  RideAttendee(this.rideDate,this.attendeeId): assert(rideDate != null && attendeeId != null && attendeeId.isNotEmpty);

  ///The date of the ride that belongs to this record.
  final DateTime rideDate;
  ///The GUID of the attendee that belongs to this record.
  final String attendeeId;

  static RideAttendee of(Map<String,dynamic> values){
    assert(values != null);
    return RideAttendee(values["date"],values["attendee"]);
  }

  Map<String,dynamic> toMap(){
    return {
      "date": rideDate.toIso8601String(),
      "attendee": attendeeId
    };
  }
}