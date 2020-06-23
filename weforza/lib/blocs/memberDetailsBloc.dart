import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc({
    @required this.memberRepository,
    @required this.deviceRepository,
    @required this.member,
  }): assert(
    memberRepository != null && deviceRepository != null && member != null
  );

  final MemberRepository memberRepository;
  final DeviceRepository deviceRepository;
  MemberItem member;

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

  void reloadDevices(){
    devicesFuture = getMemberDevices();
  }

  @override
  void dispose() {}

  Future<void> deleteMember() {
    return memberRepository.deleteMember(member.uuid);
  }

  Future<int> getAttendingCount(){
    return memberRepository.getAttendingCountForAttendee(member.uuid);
  }

  Future<List<Device>> getMemberDevices(){
    return deviceRepository.getOwnerDevices(member.uuid);
  }
}