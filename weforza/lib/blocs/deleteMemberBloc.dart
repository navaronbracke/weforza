
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';

///This [Bloc] provides functionality to delete a [Member].
class DeleteMemberBloc extends Bloc {
  DeleteMemberBloc(this._repository, this._memberId): assert(_repository != null && _memberId != null);

  ///The [IMemberRepository] that will handle the delete.
  final IMemberRepository _repository;
  ///The id of the to be deleted Member.
  final int _memberId;

  ///Dispose of this object.
  @override
  void dispose() {}

  ///Delete a member with the given id [_memberId].
  Future deleteMember() async {
    await _repository.deleteMember(_memberId);
  }

}