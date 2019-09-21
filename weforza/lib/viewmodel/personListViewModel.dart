
import 'package:weforza/model/person.dart';
import 'package:weforza/repository/personRepository.dart';
import 'package:weforza/widgets/personList.dart';

///This class is a view model for [PersonList].
///
///[_personRepository] manages the data for the view model.
class PersonListViewModel {
  PersonListViewModel(this._personRepository);

  final IPersonRepository _personRepository;

  Future<List<Person>> getKnownPeople() async => await _personRepository.getKnownPeople();

  //TODO manipulate people
}