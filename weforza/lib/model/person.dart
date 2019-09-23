
///This class represents a 'Known Person.'
///
///Such a person has a first name and last name.
class Person {
  Person(this._firstname,this._lastname);

  String _firstname;
  String _lastname;

  String getFirstName() => _firstname;
  String getLastName() => _lastname;
}