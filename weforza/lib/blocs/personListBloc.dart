
import 'dart:async';

import 'package:weforza/model/person.dart';
import 'package:weforza/repository/personRepository.dart';

import 'bloc.dart';

///This class represents a Bloc for PersonListPage.
class PersonListBloc extends Bloc {
  PersonListBloc(this._personRepository);

  ///The repository that will manipulate the list of people.
  final IPersonRepository _personRepository;

  ///Fetch the known people.
  Future<List<Person>> getKnownPeople() async => _personRepository.getKnownPeople();

  @override
  void dispose() {}
}