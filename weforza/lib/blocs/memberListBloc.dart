import 'dart:io';

import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/blocs/bloc.dart';

///This Bloc will load the members.
class MemberListBloc extends Bloc {
  MemberListBloc(this._repository, this._fileHandler):
        assert(_repository != null && _fileHandler != null);

  final MemberRepository _repository;
  final IFileHandler _fileHandler;

  Future<List<Member>> membersFuture;

  void loadMembersIfNotLoaded(){
    if(membersFuture == null){
      membersFuture = _loadMembers();
    }
  }

  void reloadMembers() => membersFuture = _loadMembers();

  Future<List<Member>> _loadMembers() => _repository.getMembers();

  Future<File> getMemberProfileImage(String path) => _fileHandler.loadProfileImageFromDisk(path);

  Future<int> getMemberAttendingCount(String uuid) => _repository.getAttendingCountForAttendee(uuid);

  @override
  void dispose() {}
}