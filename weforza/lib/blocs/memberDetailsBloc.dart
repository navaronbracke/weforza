import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc(this._memberRepository,this._deviceRepository): assert(_memberRepository != null && _deviceRepository != null);

  final MemberRepository _memberRepository;
  final DeviceRepository _deviceRepository;

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

  Future<List<Device>> getMemberDevices(String uuid){
    assert(uuid != null && uuid.isNotEmpty);
    return _deviceRepository.getOwnerDevices(uuid);
  }
}