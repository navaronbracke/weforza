
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';

///This BloC manages selecting a [Member] from a collection.
class MemberSelectBloc extends Bloc {

  ///The selected member for navigating.
  Member selectedMember;

  ///Setter for [selectedMember].
  ///[selected] shouldn't be null.
  set selectPerson(Member selected){
    assert(selected != null);
    selectedMember = selected;
  }

  @override
  void dispose(){}
}