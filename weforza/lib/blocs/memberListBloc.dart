
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for the member list page.
class MemberListBloc extends Bloc {
  MemberListBloc(this._repository): assert(_repository != null);

  final MemberRepository _repository;

  @override
  void dispose() {}

  Future<List<MemberItem>> loadMembers() async {
    List<Member> members = await _repository.getMembers();
    List<Future<MemberItem>> items = members.map((member) async => MemberItem(member,await _repository.loadProfileImageFromDisk(member.profileImageFilePath))).toList();
    return Future.wait(items);
  }

}