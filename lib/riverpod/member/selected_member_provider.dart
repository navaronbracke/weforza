import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';

/// This provider manages the selected member.
final selectedMemberProvider =
    StateNotifierProvider<SelectedMemberNotifier, Member?>(
  SelectedMemberNotifier.new,
);

class SelectedMemberNotifier extends StateNotifier<Member?> {
  SelectedMemberNotifier(this.ref) : super(null);

  final Ref ref;

  Future<void> deleteMember() async {
    final member = state;

    if (member == null) {
      return Future.error(ArgumentError.notNull('selected member'));
    }

    await ref.read(memberRepositoryProvider).deleteMember(member.uuid);

    // Refresh the member list, the collection has one member less.
    ref.refresh(memberListProvider);

    // Remove the stale selected ride. Its attendees are now possibly out of date.
    ref.read(selectedRideProvider.notifier).setSelectedRide(null);
  }

  void setMemberActive(bool value) async {
    final member = state;

    if (member == null || member.active == value) {
      return;
    }

    try {
      final repository = ref.read(memberRepositoryProvider);

      await repository.setMemberActive(member.uuid, value);

      state = Member(
        active: value,
        alias: member.alias,
        firstName: member.firstName,
        lastName: member.lastName,
        lastUpdated: DateTime.now(),
        profileImageFilePath: member.profileImageFilePath,
        uuid: member.uuid,
      );

      ref.refresh(memberListProvider);
    } catch (error) {
      // Errors are ignored.
    }
  }

  void setSelectedMember(Member member) {
    if (state != member) {
      state = member;
    }
  }
}
