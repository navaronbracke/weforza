
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';

///This class is the BLoC for RideListMemberItem.
class RideListMemberItemBloc extends Bloc {
  RideListMemberItemBloc(this._member): assert(_member != null);

  final Member _member;

  String get imageFilename => _member.profileImageFileName;

  String get firstName => _member.firstname;

  String get lastName => _member.lastname;

  @override
  void dispose() {}

}