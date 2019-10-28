
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._member): assert(_member != null);

  ///The [Member] that should be displayed.
  final Member _member;

  ///Get the first name of [_member].
  String get firstName => _member.firstname;
  ///Get the last name of [_member].
  String get lastName => _member.lastname;
  ///Get the phone of [_member].
  String get phone => _member.phone;
  ///Get the amount of times [_member] was present.
  int get wasPresentCount => _member.wasPresentCount;
  ///Get the list of devices of [_member].
  List<String> get devices => List.unmodifiable(_member.devices);
  ///Get the id of the member.
  int get id => _member.id;
  ///Get the filename of the image.
  String get imageFileName => _member.profileImageFileName;

  ///Dispose of this object.
  @override
  void dispose() {}


}