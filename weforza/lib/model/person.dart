
import 'package:flutter/foundation.dart';

///This class represents a 'Known Person.'
///
///Such a person has a first name, last name and a phone number.
class Person {
  ///Regex for a person's first or last name.
  ///
  ///The Regex is language independent.
  ///Allows hyphen,apostrophe and spaces.
  ///Between 1 and 50 characters(inclusive).
  static final RegExp personNameRegex = RegExp(r"^([\p{Letter}\s]|['-]){1,50}$",unicode: true);

  ///Regex for a person's phone number.
  ///Allows 8 to 15 digits. (15 digits is the maximum according to the E.164 standard).
  static final RegExp phoneNumberRegex = RegExp(r"\d{8,15}");

  Person(this.firstname,this.lastname,this.phone): assert(firstname != null && lastname != null && phone != null);

  //Note that [_phone] is a String, integers can't do leading zeroes.
  String phone;
  String firstname;
  String lastname;
}