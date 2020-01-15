import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._memberRepository): assert(_memberRepository != null);

  final MemberRepository _memberRepository;

  ///Dispose of this object.
  @override
  void dispose() {}

  Future<void> deleteMember(String uuid) async {
    assert(uuid != null && uuid.isNotEmpty);
    await _memberRepository.deleteMember(uuid);
  }

  Future<int> getAttendingCount(String uuid){
    assert(uuid != null && uuid.isNotEmpty);
    return _memberRepository.getAttendingCountForAttendee(uuid);
  }
}