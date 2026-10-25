import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';

/// This provider manages the selected ride.
final selectedRideProvider = NotifierProvider<SelectedRideNotifier, Ride?>(SelectedRideNotifier.new);

class SelectedRideNotifier extends Notifier<Ride?> {
  @override
  Ride? build() => null;

  Future<void> deleteRide() async {
    final ride = state;

    if (ride == null) {
      throw ArgumentError.notNull('ride');
    }

    await ref.read(rideRepositoryProvider).deleteRide(ride);

    // Refresh the ride list, there is a ride less in the collection.
    ref.invalidate(rideListProvider);

    // Refresh the rider list, the riders might have a reduced attending count.
    ref.invalidate(riderListProvider);
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
