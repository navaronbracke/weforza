import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';

/// This provider provides the attending count for the selected member.
final selectedMemberAttendingCountProvider = FutureProvider<int?>((ref) {
  final member = ref.watch(selectedMemberProvider);
  final repository = ref.read(memberRepositoryProvider);

  if (member == null) {
    return Future.value(null);
  }

  return repository.getAttendingCount(member.uuid);
});
