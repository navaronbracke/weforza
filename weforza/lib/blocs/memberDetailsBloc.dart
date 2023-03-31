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
    @required this.attendingCountFuture
  }): assert(
    memberRepository != null && deviceRepository != null && member != null
        && profileImage != null && attendingCountFuture != null
  );

  final MemberRepository memberRepository;
  final DeviceRepository deviceRepository;

  final Future<int> attendingCountFuture;
  Member member;
  Future<File> profileImage;

  Future<List<Device>> devicesFuture;

  void loadDevices(){
    if(devicesFuture == null){
      devicesFuture = getMemberDevices();
    }
  }

  void reloadDevices(){
    devicesFuture = getMemberDevices();
  }

  @override
  void dispose() {}

  Future<void> deleteDevice(Device device) => deviceRepository.removeDevice(device);

  Future<void> deleteMember() => memberRepository.deleteMember(member.uuid);

  Future<List<Device>> getMemberDevices() => deviceRepository.getOwnerDevices(member.uuid);
}