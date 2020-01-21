
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/blocs/bloc.dart';

///This Bloc will load the members.
class MemberListBloc extends Bloc {
  MemberListBloc(this._repository): assert(_repository != null);

  final MemberRepository _repository;

  ///Internal future that is returned.
  Future<List<MemberItem>> _membersFuture;

  ///Load the members if reload is true.
  ///Return the future afterwards.
  Future<List<MemberItem>> loadMembers() async {
    if(MemberProvider.reloadMembers){
      List<Member> members = await _repository.getMembers();
      List<Future<MemberItem>> items = members.map(
              (member) async => MemberItem(member,await _repository.loadProfileImageFromDisk(member.profileImageFilePath))).toList();
      _membersFuture = Future.wait(items);
    }
    return _membersFuture;
  }

  @override
  void dispose() {}
}