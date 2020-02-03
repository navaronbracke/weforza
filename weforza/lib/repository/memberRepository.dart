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

  Future<List<Member>> getMembers() => _dao.getMembers();

  Future<bool> memberExists(String firstname, String lastname, String phone,[String uuid]) => _dao.memberExists(firstname, lastname, phone,uuid);

  Future<void> deleteMember(String uuid) => _dao.deleteMember(uuid);

  Future<void> updateMember(Member member) => _dao.updateMember(member);

  Future<int> getAttendingCountForAttendee(String uuid) => _dao.getAttendingCountForAttendee(uuid);

  Future<List<Member>> getRideAttendees(DateTime date) => _dao.getRideAttendees(date);

  Future<List<String>> getRideAttendeeIds(DateTime date) async {
    final attendees = await getRideAttendees(date);
    return attendees.map((attendee) => attendee.uuid).toList();
  }

  Future<File> chooseProfileImageFromGallery() => _fileHandler.chooseProfileImageFromGallery();

  Future<File> loadProfileImageFromDisk(String path) => _fileHandler.loadProfileImageFromDisk(path);
}