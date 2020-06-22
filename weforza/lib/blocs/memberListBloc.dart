
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/blocs/bloc.dart';

///This Bloc will load the members.
class MemberListBloc extends Bloc {
  MemberListBloc(this._repository): assert(_repository != null);

  final MemberRepository _repository;

  Future<List<MemberItem>> membersFuture;

  void loadMembersIfNotLoaded(){
    if(membersFuture == null){
      membersFuture = loadMembers();
    }
  }

  Future<List<MemberItem>> loadMembers() async {
    List<Member> members = await _repository.getMembers();
    List<Future<MemberItem>> items = members.map(
            (member) async => MemberItem(member,await _repository.loadProfileImageFromDisk(member.profileImageFilePath))).toList();
    return Future.wait(items);
  }

  @override
  void dispose() {}
}