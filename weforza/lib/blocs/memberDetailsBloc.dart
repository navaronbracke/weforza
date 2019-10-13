
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._member);

  ///The [Member] that should be displayed.
  final Member _member;

  @override
  void dispose() {}


}