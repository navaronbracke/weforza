import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/blocs/bloc.dart';

///This Bloc will load the members.
class MemberListBloc extends Bloc {
  MemberListBloc(this._repository, this._fileHandler);

  final MemberRepository _repository;
  final IFileHandler _fileHandler;

  Future<List<Member>>? membersFuture;

  BehaviorSubject<MemberFilterOption> _filterController = BehaviorSubject.seeded(MemberFilterOption.ALL);
  Stream<MemberFilterOption> get stream => _filterController.stream;

  /// Load the members, using the given filter option.
  /// Defaults to using no filter.
  void loadMembers([MemberFilterOption filter = MemberFilterOption.ALL]){
    membersFuture = _repository.getMembers(filter);
  }

  Future<File?> getMemberProfileImage(String? path) => _fileHandler.loadProfileImageFromDisk(path);

  Future<int> getMemberAttendingCount(String uuid) => _repository.getAttendingCountForAttendee(uuid);

  void onFilterChanged(MemberFilterOption option, [bool override = false]){
    if(override || option != _filterController.value){
      _filterController.add(option);
      loadMembers(option);
    }
  }

  get currentFilter => _filterController.value;

  @override
  void dispose() {
    _filterController.close();
  }
}