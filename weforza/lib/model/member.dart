import 'dart:ui';

import 'package:weforza/file/exportable.dart';

///This class represents a 'Member.'
class Member implements Exportable {
  Member(this.uuid,this.firstname,this.lastname,this.phone,[this.profileImageFilePath]):
        assert(uuid != null && uuid.isNotEmpty && firstname != null && lastname != null && phone != null);

  ///Regex for a member's first or last name.
  ///
  ///The Regex is language independent.
  ///Allows hyphen,apostrophe and spaces.
  ///Between 1 and 50 characters(inclusive).
  static final RegExp personNameRegex = RegExp(r"^([\p{Letter}\s]|['-]){1,50}$",unicode: true);

  ///Regex for a member's phone number.
  ///Allows 8 to 15 digits. (15 digits is the maximum according to the E.164 standard).
  static final RegExp phoneNumberRegex = RegExp(r"\d{8,15}");

  ///The member's GUID.
  final String uuid;

  ///A member's first name.
  String firstname;

  ///A member's last name.
  String lastname;

  ///A member's phone number.
  ///Note that [phone] is a String, integers can't do leading zeroes.
  String phone;

  ///The path to an optional profile picture.
  String profileImageFilePath;

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "firstname": firstname,
      "lastname": lastname,
      "phone": phone,
      "profile": profileImageFilePath
    };
  }

  ///Create a member from a Map and a given uuid.
  static Member of(String uuid,Map<String,dynamic> values){
    assert(uuid != null && uuid.isNotEmpty && values != null);
    return Member(uuid,values["firstname"],values["lastname"],values["phone"],values["profile"]);
  }

  //If the uuid is the same, it is the same member.
  //Otherwise it is the same member if all the properties match.
  @override
  bool operator ==(Object other){
    return other is Member
        && firstname == other.firstname
        && lastname == other.lastname
        && phone == other.phone;
  }

  @override
  int get hashCode => hashValues(firstname, lastname, phone);

  @override
  Map<String, String> exportToJson() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "phone": phone
    };
  }

  @override
  String exportToCsv() => "$firstname,$lastname,$phone";
}