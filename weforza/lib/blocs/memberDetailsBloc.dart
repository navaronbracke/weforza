
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._memberRepository): assert(_memberRepository != null);

  final MemberRepository _memberRepository;

  ///Dispose of this object.
  @override
  void dispose() {}

  Future<File> loadProfileImage(String path) => _memberRepository.loadProfileImageFromDisk(path);

  Future deleteMember(Member member) async {
    assert(member != null);
    await _memberRepository.deleteMember(member.uuid);
  }

  Future<int> getAttendingCount(Member member){
    assert(member != null);
    return _memberRepository.getAttendingCountForAttendee(member.uuid);
  }
}