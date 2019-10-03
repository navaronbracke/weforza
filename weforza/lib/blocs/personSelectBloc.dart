
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/person.dart';

class PersonSelectBloc extends Bloc {

  ///The selected person for navigating.
  Person _selectedPerson;

  ///Setter for [_selectedPerson].
  ///[selected] shouldn't be null.
  set person(Person selected){
    assert(selected != null);
    _selectedPerson = selected;
  }

  ///Getter for [_selectedPerson].
  Person get person => _selectedPerson;

  @override
  void dispose(){}
}