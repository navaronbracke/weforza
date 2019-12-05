import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
  ///Check if there are members.
  Future<bool> hasMembers();
  ///Pick a profile image.
  Future<File> pickImage();
}

///This class will manage the members when in a production setting.
class MemberRepository implements IMemberRepository {
  MemberRepository(this._dao): assert(_dao != null);

  ///The internal DAO instance.
  final MemberDao _dao;

  ///See [IMemberRepository].
  @override
  Future addMember(Member member) => _dao.addMember(member);

  ///See [IMemberRepository].
  @override
  Future<List<Member>> getAllMembers() => _dao.getMembers();

  ///See [IMemberRepository].
  @override
  Future deleteMember(int id) async => _dao.deleteMember(id);

  ///See [IMemberRepository].
  @override
  Future<bool> checkIfExists(String firstname,String lastname, String phone)async => _dao.checkIfExists(firstname, lastname, phone);

  ///See [IMemberRepository].
  @override
  Future editMember(Member member) => _dao.editMember(member);

  @override
  Future<bool> hasMembers() => _dao.hasMembers();

  @override
  Future<File> pickImage() => FilePicker.getFile(type: FileType.IMAGE);
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
        m.profileImageFilePath = member.profileImageFilePath;
        m.devices = member.devices;
      }
    }
    throw Exception("$member was null");
  }

  @override
  Future<bool> hasMembers() => Future.value(_list.isNotEmpty);

  @override
  Future<File> pickImage() => null;
}