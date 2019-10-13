import 'dart:async';

import 'package:weforza/model/person.dart';

///This interface defines a contract for manipulating known people.
abstract class IPersonRepository {

  ///Get a list of all known people
  Future<List<Person>> getKnownPeople();
  ///Add a person to the list of known people
  Future<void> addPerson(Person person);
  ///Remove a person from the list of known people
  Future<void> deletePerson(Person person);
}

///This class will manage the known people.
class PersonRepository implements IPersonRepository {

  const PersonRepository();

  @override
  Future<void> addPerson(Person person) async {
    // TODO: implement addPerson
  }

  @override
  Future<void> deletePerson(Person person) async {
    // TODO: implement deletePerson
  }

  @override
  Future<List<Person>> getKnownPeople() async {
    // TODO: implement getKnownPeople
    //Placeholder until I get the database up.
    return Future.value(List.of([Person("Rudy","Bracke","0000000000"),Person("Navaron","Bracke","0000000000")]));
  }
}

///This class is a test version of [IPersonRepository].
class TestPersonRepository implements IPersonRepository {
  TestPersonRepository();

  final List<Person> _list = List<Person>();

  @override
  Future<void> addPerson(Person person) async {
    _list.add(person);
  }

  @override
  Future<void> deletePerson(Person person) async {
    _list.remove(person);
  }

  @override
  Future<List<Person>> getKnownPeople() async {
    return Future.value(List.of([Person("Rudy","Bracke","0000000000"),Person("Navaron","Bracke","0000000000")]));
  }
}