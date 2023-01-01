import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';

// TODO: use select on the uuid to fix bug with active toggle

/// This provider provides the attending count for the selected rider.
final selectedMemberAttendingCountProvider = FutureProvider<int?>((ref) async {
  final rider = ref.watch(selectedMemberProvider);
  final repository = ref.read(memberRepositoryProvider);

  if (rider == null) {
    return null;
  }

  return repository.getAttendingCount(rider.uuid);
});
