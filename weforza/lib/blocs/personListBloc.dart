
import 'dart:async';

import 'package:weforza/model/person.dart';
import 'package:weforza/repository/personRepository.dart';

import 'bloc.dart';

///This class represents a Bloc for the PersonListPage Widget.
class PersonListBloc extends Bloc {
  PersonListBloc(this._personRepository);

  ///The repository that will manipulate the list of people.
  final IPersonRepository _personRepository;

  ///The [StreamController] that manages the input [Sink]/output [Stream].
  final StreamController<List<Person>> _streamController = StreamController();

  ///The data [Stream] that can be observed for values.
  Stream<List<Person>> get stream => _streamController.stream;

  ///Fetch the known people.
  ///This passes any value or error to [stream].
  getKnownPeople() async => _streamController.add(await _personRepository.getKnownPeople());

  //TODO manipulate people


  @override
  void dispose() {
    _streamController.close();
  }
}