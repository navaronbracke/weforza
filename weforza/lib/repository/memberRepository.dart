import 'dart:async';

import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/member.dart';

///This interface defines a contract for manipulating members.
abstract class IMemberRepository {

  ///Get a list of all members.
  Future<List<Member>> getAllMembers();
  ///Add a member to the list of members.
  Future addMember(Member member);
  ///Remove a member.
  Future deleteMember(int id);
  ///Check if a given member exists with the given values.
  Future<bool> checkIfExists(String firstname,String lastname, String phone);
  ///Edit member.
  Future editMember(Member member);
}

///This class will manage the members when in a production setting.
class MemberRepository implements IMemberRepository {
  MemberRepository(this._dao): assert(_dao != null);

  final MemberDao _dao;

  @override
  Future addMember(Member member) => _dao.addMember(member);

  @override
  Future<List<Member>> getAllMembers() => _dao.getMembers();

  @override
  Future deleteMember(int id) async {
    // TODO: implement deletePerson
  }

  @override
  Future<bool> checkIfExists(String firstname,String lastname, String phone)async => _dao.checkIfExists(firstname, lastname, phone);

  @override
  Future editMember(Member member) {
    // TODO: implement editMember
    return null;
  }
}

///This class is a test version of [IMemberRepository].
class TestMemberRepository implements IMemberRepository {
  TestMemberRepository();

  final List<Member> _list = List();

  @override
  Future addMember(Member member){
    _list.add(member);
    return null;
  }

  @override
  Future deleteMember(int id) {
    _list.removeWhere((m) => m.id == id);
    return null;
  }

  @override
  Future<List<Member>> getAllMembers() {
    return Future.value(_list);
  }

  @override
  Future<bool> checkIfExists(String firstname,String lastname, String phone) {
    return Future.value(_list.firstWhere((m) => m != null && m.firstname == firstname && m.lastname == lastname && m.phone == phone,orElse: null) != null);
  }

  @override
  Future editMember(Member member) {
    if(member != null){
      Member m = _list.firstWhere((m)=> m.id == member.id,orElse: null);
      if(m != null){
        m.phone = member.phone;
        m.firstname = member.firstname;
        m.lastname = member.lastname;
        m.profileImageFileName = member.profileImageFileName;
        m.wasPresentCount = member.wasPresentCount;
        m.devices = member.devices;
      }
    }
    throw Exception("$member was null");
  }
}