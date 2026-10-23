import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';

/// This provider provides the attending count for the selected rider.
final selectedRiderAttendingCountProvider = FutureProvider<int?>((ref) async {
  final id = ref.watch(selectedRiderProvider.select((r) => r?.id));
  final repository = ref.watch(riderRepositoryProvider);

  return id == null ? null : repository.getAttendingCount(id);
});
