
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileLoader.dart';
import 'package:weforza/model/member.dart';

///This class is the BLoC for RideListMemberItem.
class RideListAttendeeItemBloc extends Bloc {
  RideListAttendeeItemBloc(this._member,this.selected): assert(_member != null && selected != null);

  bool selected;

  final Member _member;

  String get firstName => _member.firstname;

  String get lastName => _member.lastname;

  Future<File> getImage() => FileLoader.getImage(_member.profileImageFilePath);

  @override
  void dispose() {}

}