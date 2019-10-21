import 'dart:async';

import 'package:weforza/database/databaseProvider.dart';
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
  MemberRepository(this._database): assert(_database != null);

  final IDatabaseProvider _database;

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
    return Future.value(List.of([Member("Rudy","Bracke","0000000000",List<String>()),Member("Navaron","Bracke","0000000000",List<String>())]));
  }
}

///This class is a test version of [IMemberRepository].
class TestMemberRepository implements IMemberRepository {
  TestMemberRepository(this._database): assert(_database != null);

  final IDatabaseProvider _database;

  @override
  Future<void> addMember(Member member) async {
    //_list.add(member);
  }

  @override
  Future<void> deleteMember(Member member) async {
    //_list.remove(member);
  }

  @override
  Future<List<Member>> getAllMembers() async {
    //TODO replace with database
    return Future.value(List.of([Member("Rudy","Bracke","0000000000",List<String>()),Member("Navaron","Bracke","0000000000",List<String>())]));
  }
}