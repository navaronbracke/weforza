
///This class represents a 'Known Person.'
///
///Such a person has a first name, last name and a phone number.
class Person {
  ///A [RegExp] for a person's first or last name.
  ///
  ///Names start with an uppercase letter.
  ///Names are at least 2 characters long.
  ///Names can contain (A-Za-zéè) after the first letter.
  static final RegExp personNameRegex = RegExp(r"^([A-Z][a-zéè])([a-zA-Zéè -]{0,})$");

  static final RegExp personPhone = RegExp(r"^[0-9]$");

  ///The max length for a phone number according to the E.164 standard.
  static final int phoneNumberMaxLength = 15;

  Person(this._firstname,this._lastname,this._phone);

  //Note that [_phone] is a String, integers can't do leading zeroes.
  String _phone;
  String _firstname;
  String _lastname;

  String getFirstName() => _firstname;
  String getLastName() => _lastname;
  String getPhone() => _phone;
}