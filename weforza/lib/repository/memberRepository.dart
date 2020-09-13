import 'dart:async';
import 'dart:io';

import 'package:weforza/database/memberDao.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/member.dart';

///This class provides an API to work with members.
class MemberRepository {
  MemberRepository(this._dao,this._fileHandler): assert(_dao != null && _fileHandler != null);

  ///The internal DAO instance.
  final IMemberDao _dao;
  ///The internal [IFileHandler] instance.
  final IFileHandler _fileHandler;

  Future<void> addMember(Member member) => _dao.addMember(member);

  Future<List<Member>> getMembers({Set<String> uuids}) => _dao.getMembers(uuids: uuids);

  Future<Member> getMemberByUuid(String uuid) => _dao.getMemberByUuid(uuid);

  Future<bool> memberExists(String firstname, String lastname, String alias, [String uuid]) => _dao.memberExists(firstname, lastname, alias, uuid);

  Future<void> deleteMember(String uuid) => _dao.deleteMember(uuid);

  Future<void> updateMember(Member member) => _dao.updateMember(member);

  Future<int> getAttendingCountForAttendee(String uuid) => _dao.getAttendingCountForAttendee(uuid);

  Future<File> chooseProfileImageFromGallery() => _fileHandler.chooseProfileImageFromGallery();

  Future<File> loadProfileImageFromDisk(String path) => _fileHandler.loadProfileImageFromDisk(path);
}