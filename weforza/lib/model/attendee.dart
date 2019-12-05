
import 'package:flutter/widgets.dart';

///This class represents an Attendee for a [Ride].
class Attendee {
  Attendee(this.firstname,this.lastname,this.phone): assert(firstname != null && lastname != null && phone != null);

  ///The attendee's first name.
  final String firstname;
  ///The attendee's last name.
  final String lastname;
  ///The attendee's phone.
  final String phone;

  static Attendee fromMap(Map<String,dynamic> map) => Attendee(map["firstname"],map["lastname"],map["phone"]);

  Map<String,dynamic> toMap() => {
    "firstname": firstname,
    "lastname": lastname,
    "phone": phone,
  };

  @override
  bool operator ==(Object other) => other is Attendee && firstname == other.firstname && lastname == other.lastname && phone == other.phone;

  @override
  int get hashCode => hashValues(firstname, lastname,phone);
}