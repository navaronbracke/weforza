
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._memberRepository,this._rideRepository): assert(_memberRepository != null && _rideRepository != null);

  final IMemberRepository _memberRepository;
  final IRideRepository _rideRepository;

  ///Dispose of this object.
  @override
  void dispose() {}

  Future<File> getImage(String path) => _memberRepository.getImage(path);

  Future deleteMember(Member member) async {
    assert(member != null);
    await _rideRepository.removeAttendeeFromRides(Attendee(member.firstname,member.lastname,member.phone));
    await _memberRepository.deleteMember(member.id);
  }

  Future<int> getAttendingCount(Member member){
    assert(member != null);
    return _rideRepository.getAttendingCount(Attendee(member.firstname,member.lastname,member.phone));
  }
}