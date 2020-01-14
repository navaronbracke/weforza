
import 'dart:io';

///This class wraps an Attendee together with its profile picture.
class AttendeeItem {
  AttendeeItem(this.uuid,this.firstName,this.lastName,this.picture): assert(uuid != null && uuid.isNotEmpty && firstName != null && lastName != null);

  final String uuid;
  final String firstName;
  final String lastName;
  final File picture;
}