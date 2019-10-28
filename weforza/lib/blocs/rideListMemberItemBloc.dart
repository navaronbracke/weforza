
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';

///This class is the BLoC for RideListMemberItem.
class RideListMemberItemBloc extends Bloc {
  RideListMemberItemBloc(this._member): assert(_member != null);

  final Member _member;

  String get imageFilename => _member.profileImageFileName;

  String get firstName => _member.firstname;

  String get lastName => _member.lastname;

  Future<File> getImage() async {
    if(_member.profileImageFileName == null) return Future.value(null);
    else {
      final documentsDir = await getApplicationDocumentsDirectory();
      File image = File(join(documentsDir.path,_member.profileImageFileName));
      return await image.exists() ? image : null;
    }
  }

  @override
  void dispose() {}

}