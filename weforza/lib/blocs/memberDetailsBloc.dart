
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileLoader.dart';
import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._member,this._memberRepository,this._rideRepository): assert(_member != null && _memberRepository != null && _rideRepository != null);

  ///The [Member] that should be displayed.
  final Member _member;
  final IMemberRepository _memberRepository;
  final IRideRepository _rideRepository;

  ///Get the first name of [_member].
  String get firstName => _member.firstname;
  ///Get the last name of [_member].
  String get lastName => _member.lastname;
  ///Get the phone of [_member].
  String get phone => _member.phone;
  ///Get the list of devices of [_member].
  List<String> get devices => List.unmodifiable(_member.devices);
  ///Get the id of the member.
  int get id => _member.id;
  ///Get the filename of the image.
  String get imageFileName => _member.profileImageFilePath;

  ///Dispose of this object.
  @override
  void dispose() {}

  Future<File> getImage() => FileLoader.getImage(_member.profileImageFilePath);

  Future deleteMember() async {
    await _rideRepository.removeAttendeeFromRides(Attendee(_member.firstname,_member.lastname,_member.phone));
    await _memberRepository.deleteMember(_member.id);
  }

  //TODO future for was present count


}