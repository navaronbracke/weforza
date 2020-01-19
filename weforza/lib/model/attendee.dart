
import 'package:flutter/widgets.dart';

///This class represents an Attendee for a [Ride].
class Attendee {
  Attendee(this.uuid,this.firstname,this.lastname,this.image): assert(uuid != null && uuid.isNotEmpty && firstname != null && lastname != null);

  ///The GUID for the attendee.
  final String uuid;
  ///The attendee's first name.
  final String firstname;
  ///The attendee's last name.
  final String lastname;
  ///The file path of the attendee's profile image.
  final String image;

  static Attendee of(String uuid,Map<String,dynamic> values){
    assert(values != null);
    return Attendee(uuid,values["firstname"],values["lastname"],values["profile"]);
  }

  @override
  bool operator ==(Object other) => other is Attendee && uuid == other.uuid && firstname == other.firstname && lastname == other.lastname && image == other.image;

  @override
  int get hashCode => hashValues(firstname, lastname,uuid,image);
}