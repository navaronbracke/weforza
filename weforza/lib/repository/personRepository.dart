import 'package:flutter/widgets.dart';
import 'package:weforza/model/person.dart';

///This interface defines a contract for manipulating known people.
abstract class IPersonRepository {

  ///Get a list of all known people
  Future<List<Person>> getKnownPeople();
  //Add a person to the list of known people
  void addPerson(Person person);
  ///Remove a person from the list of known people
  void deletePerson(Person person);
}

///This class will manage the known people.
class PersonRepository implements IPersonRepository {

  const PersonRepository();

  @override
  void addPerson(Person person) async {
    // TODO: implement addPerson
  }

  @override
  void deletePerson(Person person) async {
    // TODO: implement deletePerson
  }

  @override
  Future<List<Person>> getKnownPeople() async {
    // TODO: implement getKnownPeople

    //Placeholder
    return List.generate(15, (index) => Person("Firstname $index","Lastname $index"));
  }
}