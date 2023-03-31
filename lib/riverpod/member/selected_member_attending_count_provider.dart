import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';

/// This provider provides the attending count for the selected rider.
final selectedMemberAttendingCountProvider = FutureProvider<int?>((ref) async {
  final uuid = ref.watch(selectedMemberProvider.select((r) => r?.uuid));
  final repository = ref.read(memberRepositoryProvider);

  if (uuid == null) {
    return null;
  }

  return repository.getAttendingCount(uuid);
});