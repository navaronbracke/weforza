import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/selected_member.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';

/// This provider manages the selected member.
final selectedMemberProvider =
    StateNotifierProvider<SelectedMemberNotifier, SelectedMember?>(
  (ref) {
    final deviceRepository = ref.read(deviceRepositoryProvider);
    final memberRepository = ref.read(memberRepositoryProvider);
    final memberList = ref.read(memberListProvider.notifier);

    return SelectedMemberNotifier(
      deviceRepository,
      memberRepository,
      memberList,
    );
  },
);

class SelectedMemberNotifier extends StateNotifier<SelectedMember?> {
  SelectedMemberNotifier(
    this.deviceRepository,
    this.memberRepository,
    this.memberList,
  ) : super(null);

  final DeviceRepository deviceRepository;

  final MemberRepository memberRepository;

  final MemberListNotifier memberList;

  /// The backing list for the devices.
  List<Device> _memberDevices = [];

  bool get hasNoDevices => _memberDevices.isEmpty;

  Future<Device> deleteDevice(int index) async {
    final device = _memberDevices[index];

    await deviceRepository.removeDevice(device);

    _memberDevices.removeAt(index);

    return device;
  }

  Future<void> deleteMember() async {
    final member = state;

    if (member == null) {
      return Future.error(ArgumentError.notNull('selected member'));
    }

    await memberRepository.deleteMember(member.value.uuid);

    // Refresh the member list.
    memberList.getMembers();
  }

  void reloadDevices() {
    final member = state;

    if (member == null) {
      return;
    }

    // Calling `setSelectedMember()` refreshes the devices list.
    setSelectedMember(
      attendingCount: member.attendingCount,
      member: member.value,
      profileImage: member.profileImage,
    );
  }

  void setMemberActive(bool value) async {
    final member = state;

    if (member == null || member.value.isActiveMember == value) {
      return;
    }

    try {
      await memberRepository.setMemberActive(member.value.uuid, value);

      state = SelectedMember(
        attendingCount: member.attendingCount,
        devices: member.devices,
        profileImage: member.profileImage,
        value: Member(
          alias: member.value.alias,
          firstname: member.value.firstname,
          isActiveMember: value,
          lastUpdated: DateTime.now(),
          lastname: member.value.lastname,
          profileImageFilePath: member.value.profileImageFilePath,
          uuid: member.value.uuid,
        ),
      );

      memberList.getMembers();
    } catch (error) {
      // Errors are ignored.
    }
  }

  void setSelectedMember({
    required Future<int> attendingCount,
    required Member member,
    required Future<File?> profileImage,
  }) {
    state = SelectedMember(
      attendingCount: attendingCount,
      devices: deviceRepository.getOwnerDevices(member.uuid).then((value) {
        _memberDevices = value;

        return _memberDevices;
      }),
      profileImage: profileImage,
      value: member,
    );
  }
}
