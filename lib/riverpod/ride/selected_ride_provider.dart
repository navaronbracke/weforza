import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/selected_ride.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';

/// This provider manages the selected ride.
final selectedRideProvider =
    StateNotifierProvider<SelectedRideNotifier, SelectedRide?>(
  (ref) => SelectedRideNotifier(ref),
);

class SelectedRideNotifier extends StateNotifier<SelectedRide?> {
  SelectedRideNotifier(this.ref) : super(null);

  final Ref ref;

  Ride? get selectedRide => state?.value;

  void setSelectedRide({
    required Future<List<Member>> attendees,
    required Ride ride,
  }) {
    state = SelectedRide(attendees, ride);
  }

  Future<void> deleteRide() async {
    final ride = state;

    if (ride == null) {
      return Future.error(ArgumentError.notNull('selected ride'));
    }

    await ref.read(rideRepositoryProvider).deleteRide(ride.value.date);

    // Refresh the ride list.
    ref.refresh(rideListProvider);
  }
}
