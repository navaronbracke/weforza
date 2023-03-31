import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';

/// This provider provides the member list notifier.
final rideListProvider =
    StateNotifierProvider<RideListNotifier, Future<List<Ride>>?>((ref) {
  final repository = ref.read(rideRepositoryProvider);

  return RideListNotifier(repository: repository)..getRides();
});

/// This notifier manages the data for the ride list page.
class RideListNotifier extends StateNotifier<Future<List<Ride>>?> {
  RideListNotifier({required this.repository}) : super(null);

  final RideRepository repository;

  void getRides() {
    state = repository.getRides();
  }
}
