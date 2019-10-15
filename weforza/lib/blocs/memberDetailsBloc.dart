
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._member);

  ///The [Member] that should be displayed.
  final Member _member;

  String get firstName => _member.firstname;
  String get lastName => _member.lastname;
  String get phone => _member.phone;
  int get wasPresentCount => _member.wasPresentCount;
  List<String> get devices => List.unmodifiable(_member.devices);

  @override
  void dispose() {}


}