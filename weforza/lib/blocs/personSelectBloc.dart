
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/person.dart';

///This BloC manages selecting a [Person] from a collection.
class PersonSelectBloc extends Bloc {

  ///The selected person for navigating.
  Person selectedPerson;

  ///Setter for [selectedPerson].
  ///[selected] shouldn't be null.
  set selectPerson(Person selected){
    assert(selected != null);
    selectedPerson = selected;
  }

  @override
  void dispose(){}
}