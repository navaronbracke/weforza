
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileLoader.dart';
import 'package:weforza/model/member.dart';

///This class is the BLoC for RideListMemberItem.
class RideListMemberItemBloc extends Bloc {
  RideListMemberItemBloc(this._member): assert(_member != null);

  final Member _member;

  String get imageFilename => _member.profileImageFilePath;

  String get firstName => _member.firstname;

  String get lastName => _member.lastname;

  Future<File> getImage() => FileLoader.getImage(_member.profileImageFilePath);

  @override
  void dispose() {}

}