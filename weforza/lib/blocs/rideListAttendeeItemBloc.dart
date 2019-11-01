
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileLoader.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';

///This class is the BLoC for RideListMemberItem.
class RideListAttendeeItemBloc extends Bloc {
  RideListAttendeeItemBloc(this._member,this.isSelected): assert(_member != null && isSelected != null);

  bool isSelected;

  final Member _member;

  String get firstName => _member.firstname;

  String get lastName => _member.lastname;

  Future<File> getImage() => FileLoader.getImage(_member.profileImageFilePath);

  @override
  void dispose() {}

  Attendee attendeeFrom() => Attendee(firstName,lastName,_member.phone);

}