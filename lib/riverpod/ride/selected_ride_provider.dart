import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';

/// This provider manages the selected ride.
final selectedRideProvider = StateNotifierProvider<SelectedRideNotifier, Ride?>(
  SelectedRideNotifier.new,
);

/// This provider provides the list of attendees for the currently selected ride.
final selectedRideAttendeesProvider = FutureProvider<List<Rider>>((ref) async {
  final repository = ref.watch(rideRepositoryProvider);
  final selectedRide = ref.watch(selectedRideProvider);

  if (selectedRide == null) {
    throw ArgumentError.notNull('selectedRide');
  }

  return repository.getRideAttendees(selectedRide.date);
});

class SelectedRideNotifier extends StateNotifier<Ride?> {
  SelectedRideNotifier(this.ref) : super(null);

  final Ref ref;

  Future<void> deleteRide() async {
    final ride = state;

    if (ride == null) {
      throw ArgumentError.notNull('ride');
    }

    await ref.read(rideRepositoryProvider).deleteRide(ride.date);

    // Refresh the ride list, there is a ride less in the collection.
    ref.invalidate(rideListProvider);

    // Refresh the member list, the members might have a reduced attending count.
    ref.invalidate(memberListProvider);
  }

  /// Set the selected ride to [ride].
  ///
  /// If the new ride is equal to the old one, through [==],
  /// the selected ride is not updated unless [force] is true.
  ///
  /// If the new ride is [identical] to the old one,
  /// the selected ride is not updated,
  void setSelectedRide(Ride? ride, {bool force = false}) {
    if (force || state != ride) {
      state = ride;
    }
  }
}
