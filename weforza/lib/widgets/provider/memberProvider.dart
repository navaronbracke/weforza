import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class provides a selected [MemberItem] and the future for loading members.
class MemberProvider {
  MemberProvider(this._repository): assert(_repository != null);

  final MemberRepository _repository;

  MemberItem selectedMember;

  Future<List<MemberItem>> membersFuture;

  void loadMembersIfNotLoaded(){
    if(membersFuture == null){
      loadMembers();
    }
  }

  void loadMembers() async {
    List<Member> members = await _repository.getMembers();
    List<Future<MemberItem>> items = members.map((member) async => MemberItem(member,await _repository.loadProfileImageFromDisk(member.profileImageFilePath))).toList();
    membersFuture = Future.wait(items);
  }
}