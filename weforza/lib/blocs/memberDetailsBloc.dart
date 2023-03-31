import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
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
  ){
    _isActiveController = BehaviorSubject.seeded(member.isActiveMember);
  }

  final MemberRepository memberRepository;
  final DeviceRepository deviceRepository;

  StreamController<bool> _isActiveController;
  Stream<bool> get isActiveStream => _isActiveController.stream;

  final Future<int> attendingCountFuture;
  Member member;
  Future<File> profileImage;
  Future<List<Device>> devicesFuture;

  void loadDevices(){
    devicesFuture = getMemberDevices();
  }

  @override
  void dispose() {
    _isActiveController.close();
  }

  Future<void> deleteDevice(Device device) => deviceRepository.removeDevice(device);

  Future<void> deleteMember() => memberRepository.deleteMember(member.uuid);

  Future<List<Device>> getMemberDevices() => deviceRepository.getOwnerDevices(member.uuid);

  void setMemberActive(bool value) async {
    if(member.isActiveMember != value){
      await memberRepository.setMemberActive(member.uuid, value).then((_){
        member.isActiveMember = value;
        _isActiveController.add(value);
      }).catchError(_isActiveController.addError);
    }
  }
}