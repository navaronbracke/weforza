import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/selected_member.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';

/// This provider manages the selected member.
final selectedMemberProvider =
    StateNotifierProvider<SelectedMemberNotifier, SelectedMember?>(
  SelectedMemberNotifier.new,
);

class SelectedMemberNotifier extends StateNotifier<SelectedMember?> {
  SelectedMemberNotifier(this.ref) : super(null);

  final Ref ref;

  Future<void> deleteMember() async {
    final member = state;

    if (member == null) {
      return Future.error(ArgumentError.notNull('selected member'));
    }

    await ref.read(memberRepositoryProvider).deleteMember(member.value.uuid);

    // Refresh the member list, the collection has one member less.
    ref.refresh(memberListProvider);

    // Remove the stale selected ride. Its attendees are now possibly out of date.
    ref.read(selectedRideProvider.notifier).setSelectedRide(null);
  }

  void setMemberActive(bool value) async {
    final member = state;

    if (member == null || member.value.isActiveMember == value) {
      return;
    }

    try {
      final repository = ref.read(memberRepositoryProvider);

      await repository.setMemberActive(member.value.uuid, value);

      state = SelectedMember(
        attendingCount: member.attendingCount,
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

      ref.refresh(memberListProvider);
    } catch (error) {
      // Errors are ignored.
    }
  }

  void setSelectedMember({
    required Future<int> attendingCount,
    required Member member,
    File? profileImage,
  }) {
    state = SelectedMember(
      attendingCount: attendingCount,
      profileImage: profileImage,
      value: member,
    );
  }

  void updateSelectedMember({required Member member, File? profileImage}) {
    final currentState = state;

    if (currentState == null) {
      return;
    }

    final newState = SelectedMember(
      attendingCount: currentState.attendingCount,
      profileImage: profileImage,
      value: member,
    );

    if (currentState != newState) {
      state = newState;
    }
  }
}
