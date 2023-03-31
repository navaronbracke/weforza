import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/member/selected_member_attending_count_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// The provider for the attending count of a single member list item
/// is an `autoDispose` provider as there might be many items in the list,
/// that get built nd destroyed.
final _memberAttendingCount =
    FutureProvider.autoDispose.family<int, String>((ref, uuid) {
  final repository = ref.read(memberRepositoryProvider);

  return repository.getAttendingCount(uuid);
});

/// This widget represents the base attending count widget
/// that is used by [MemberListItemAttendingCount] and [SelectedMemberAttendingCount].
class _MemberAttendingCount extends StatelessWidget {
  const _MemberAttendingCount(this.value);

  final AsyncValue<int?> value;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (count) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text('${count ?? '?'}'),
            ),
            const Icon(
              Icons.directions_bike,
              color: ApplicationTheme.primaryColor,
            ),
          ],
        );
      },
      error: (error, stackTrace) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(padding: EdgeInsets.only(right: 4), child: Text('?')),
          Icon(
            Icons.directions_bike,
            color: ApplicationTheme.primaryColor,
          ),
        ],
      ),
      loading: () => const PlatformAwareLoadingIndicator(),
    );
  }
}

/// This widget represents the attending count for a member list item.
class MemberListItemAttendingCount extends ConsumerWidget {
  const MemberListItemAttendingCount({super.key, required this.member});

  final Member member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(_memberAttendingCount(member.uuid));

    return _MemberAttendingCount(value);
  }
}

/// This widget represents the attending count for the selected member.
class SelectedMemberAttendingCount extends ConsumerWidget {
  const SelectedMemberAttendingCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(selectedMemberAttendingCountProvider);

    return _MemberAttendingCount(value);
  }
}
