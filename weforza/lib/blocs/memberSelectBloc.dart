
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';

///This BloC manages selecting a [Member] from a collection.
class MemberSelectBloc extends Bloc {

  ///The selected member for navigating.
  Member _selectedMember;

  ///Setter for [_selectedMember].
  ///[selected] shouldn't be null.
  set selectedMember(Member selected){
    assert(selected != null);
    _selectedMember = selected;
  }

  ///Getter for [_selectedMember].
  Member get selectedMember => _selectedMember;

  ///Dispose of this object.
  @override
  void dispose(){}
}