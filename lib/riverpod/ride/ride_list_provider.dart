import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';

/// This provider provides the list of rides.
final rideListProvider = FutureProvider<List<Ride>>((ref) {
  final repository = ref.read(rideRepositoryProvider);

  return repository.getRides();
});
