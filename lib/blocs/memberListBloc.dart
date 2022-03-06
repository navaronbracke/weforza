import 'dart:async';
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';

///This Bloc will load the members.
class MemberListBloc extends Bloc {
  MemberListBloc(this._repository, this._settingsRepository, this._fileHandler);

  final MemberRepository _repository;
  final SettingsRepository _settingsRepository;
  final IFileHandler _fileHandler;

  Future<List<Member>>? membersFuture;

  /// Load the members.
  /// This function first does a lookup for the settings that contain the specified filter value.
  void loadMembers() {
    membersFuture =
        _settingsRepository.loadApplicationSettings().then((settings) {
      return _repository.getMembers(settings.memberListFilter);
    });
  }

  Future<File?> getMemberProfileImage(String? path) =>
      _fileHandler.loadProfileImageFromDisk(path);

  Future<int> getMemberAttendingCount(String uuid) =>
      _repository.getAttendingCountForAttendee(uuid);

  @override
  void dispose() {}
}
