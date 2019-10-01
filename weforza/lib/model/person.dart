
///This class represents a 'Known Person.'
///
///Such a person has a first name, last name and a phone number.
class Person {
  Person(this._firstname,this._lastname,this._phone);

  //Note that [_phone] is a String, integers can't do leading zeroes.
  String _phone;
  String _firstname;
  String _lastname;

  String getFirstName() => _firstname;
  String getLastName() => _lastname;
  String getPhone() => _phone;
}