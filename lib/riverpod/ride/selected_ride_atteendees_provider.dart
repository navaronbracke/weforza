import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';

/// This provider provides the list of attendees for the currently selected ride.
final selectedRideAttendeesProvider = FutureProvider<List<Rider>>((ref) async {
  final repository = ref.watch(rideRepositoryProvider);
  final selectedRide = ref.watch(selectedRideProvider);

  if (selectedRide == null) {
    throw ArgumentError.notNull('selectedRide');
  }

  return repository.getRideAttendees(selectedRide.date);
});
