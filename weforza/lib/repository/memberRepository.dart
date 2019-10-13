import 'dart:async';

import 'package:weforza/model/member.dart';

///This interface defines a contract for manipulating members.
abstract class IMemberRepository {

  ///Get a list of all members.
  Future<List<Member>> getAllMembers();
  ///Add a member to the list of members.
  Future<void> addMember(Member member);
  ///Remove a member.
  Future<void> deleteMember(Member member);
}

///This class will manage the members when in a production setting.
class MemberRepository implements IMemberRepository {

  const MemberRepository();

  @override
  Future<void> addMember(Member member) async {
    // TODO: implement addMember
  }

  @override
  Future<void> deleteMember(Member member) async {
    // TODO: implement deletePerson
  }

  @override
  Future<List<Member>> getAllMembers() async {
    // TODO: implement
    //Placeholder until I get the database up.
    return Future.value(List.of([Member("Rudy","Bracke","0000000000"),Member("Navaron","Bracke","0000000000")]));
  }
}

///This class is a test version of [IMemberRepository].
class TestMemberRepository implements IMemberRepository {
  TestMemberRepository();

  final List<Member> _list = List<Member>();

  @override
  Future<void> addMember(Member member) async {
    _list.add(member);
  }

  @override
  Future<void> deleteMember(Member member) async {
    _list.remove(member);
  }

  @override
  Future<List<Member>> getAllMembers() async {
    return Future.value(List.of([Member("Rudy","Bracke","0000000000"),Member("Navaron","Bracke","0000000000")]));
  }
}