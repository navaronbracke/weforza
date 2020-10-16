import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for MemberDetailsPage.
class MemberDetailsBloc extends Bloc {
  MemberDetailsBloc({
    @required this.memberRepository,
    @required this.deviceRepository,
    @required this.member,
    @required this.profileImage,
  }): assert(
    memberRepository != null && deviceRepository != null && member != null && profileImage != null
  );

  final MemberRepository memberRepository;
  final DeviceRepository deviceRepository;
  Member member;
  Future<File> profileImage;

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

  Future<void> deleteDevice(Device device) => deviceRepository.removeDevice(device);

  Future<void> deleteMember() => memberRepository.deleteMember(member.uuid);

  Future<int> getAttendingCount() => memberRepository.getAttendingCountForAttendee(member.uuid);

  Future<List<Device>> getMemberDevices() => deviceRepository.getOwnerDevices(member.uuid);
}