import 'dart:io';

import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/blocs/bloc.dart';

///This Bloc will load the members.
class MemberListBloc extends Bloc {
  MemberListBloc(this._repository, this._fileHandler):
        assert(_repository != null && _fileHandler != null);

  final MemberRepository _repository;
  final IFileHandler _fileHandler;

  Future<List<Member>> membersFuture;

  MemberFilterOption _currentFilter = MemberFilterOption.ALL;

  /// Load the members, using the given filter option.
  /// Defaults to using no filter.
  void loadMembers([MemberFilterOption filter = MemberFilterOption.ALL]){
    membersFuture = _repository.getMembers(filter);
  }

  Future<File> getMemberProfileImage(String path) => _fileHandler.loadProfileImageFromDisk(path);

  Future<int> getMemberAttendingCount(String uuid) => _repository.getAttendingCountForAttendee(uuid);

  void onFilterChanged(MemberFilterOption filterOption){
    if(filterOption != _currentFilter){
      _currentFilter = filterOption;
      loadMembers(filterOption);
    }
  }

  @override
  void dispose() {}
}