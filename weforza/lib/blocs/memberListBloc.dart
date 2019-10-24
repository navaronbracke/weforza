
import 'dart:async';

import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';

import 'bloc.dart';

///This class represents a Bloc for MemberListPage.
class MemberListBloc extends Bloc {
  MemberListBloc(this._memberRepository):assert(_memberRepository != null);

  ///The repository that will manipulate the list of members.
  final IMemberRepository _memberRepository;

  ///Fetch the known people.
  Future<List<Member>> getKnownPeople() => _memberRepository.getAllMembers();

  @override
  void dispose() {}
}