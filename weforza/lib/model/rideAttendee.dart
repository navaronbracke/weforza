import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/ride.dart';

///This class represents an intermediary table that connects [Ride] with [Attendee].
class RideAttendee {
  RideAttendee(this.uuid,this.rideDate,this.attendeeId): assert(uuid != null && uuid.isNotEmpty && rideDate != null && attendeeId != null && attendeeId.isNotEmpty);
  ///The GUID of this record.
  final String uuid;
  ///The date of the ride that belongs to this record.
  final DateTime rideDate;
  ///The GUID of the attendee that belongs to this record.
  final String attendeeId;

  static RideAttendee of(String uuid,Map<String,dynamic> values){
    assert(uuid != null && uuid.isNotEmpty && values != null);
    return RideAttendee(uuid,values["date"],values["attendee"]);
  }

  Map<String,dynamic> toMap(){
    return {
      "date": rideDate.toIso8601String(),
      "attendee": attendeeId
    };
  }
}