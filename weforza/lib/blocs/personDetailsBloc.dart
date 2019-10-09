
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/person.dart';

class PersonDetailsBloc extends Bloc {
  PersonDetailsBloc(this._person);
  ///The [Person] that should be displayed.
  final Person _person;

  @override
  void dispose() {}


}