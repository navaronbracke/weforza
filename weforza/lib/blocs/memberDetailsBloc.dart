import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc({
    @required this.memberRepository,
    @required this.deviceRepository,
    @required this.memberUuid,
  }): assert(
    memberRepository != null && deviceRepository != null && memberUuid != null
        && memberUuid.isNotEmpty
  );

  final MemberRepository memberRepository;
  final DeviceRepository deviceRepository;
  final String memberUuid;

  Future<List<Device>> devicesFuture;

  Future<int> attendingCountFuture;

  void loadDevicesAndAttendingCount(){
    if(devicesFuture == null){
      devicesFuture = getMemberDevices();
    }
    if(attendingCountFuture == null){
      attendingCountFuture = getAttendingCount();
    }
  }

  ///Dispose of this object.
  @override
  void dispose() {}

  Future<void> deleteMember() async {
    await memberRepository.deleteMember(memberUuid);
  }

  Future<int> getAttendingCount(){
    return memberRepository.getAttendingCountForAttendee(memberUuid);
  }

  Future<List<Device>> getMemberDevices(){
    return deviceRepository.getOwnerDevices(memberUuid);
  }
}