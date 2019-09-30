
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/person.dart';

class PersonSelectBloc implements Bloc {

  ///The selected person for navigating.
  Person _selectedPerson;

  set person(Person selected){
    assert(selected != null);
    _selectedPerson = selected;
  }

  Person get person => _selectedPerson;

  @override
  void dispose(){}
}