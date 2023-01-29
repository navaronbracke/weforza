import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';

/// This provider provides the attending count for the selected rider.
final selectedRiderAttendingCountProvider = FutureProvider<int?>((ref) async {
  final uuid = ref.watch(selectedRiderProvider.select((r) => r?.uuid));
  final repository = ref.read(riderRepositoryProvider);

  if (uuid == null) {
    return null;
  }

  return repository.getAttendingCount(uuid);
});
