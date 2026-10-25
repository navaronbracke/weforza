import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';

/// This provider manages the selected rider.
final selectedRiderProvider = NotifierProvider<SelectedRiderNotifier, Rider?>(SelectedRiderNotifier.new);

class SelectedRiderNotifier extends Notifier<Rider?> {
  @override
  Rider? build() => null;

  Future<void> deleteRider() async {
    final rider = state;

    if (rider == null) {
      throw ArgumentError.notNull('rider');
    }

    await ref.read(riderRepositoryProvider).deleteRider(rider);

    // Refresh the rider list, the collection has one item less.
    ref.invalidate(riderListProvider);

    // Remove the stale selected ride. Its attendees are now possibly out of date.
    ref.read(selectedRideProvider.notifier).setSelectedRide(null);
  }

  void setRiderActive({required bool value}) async {
    final rider = state;

    if (rider == null || rider.isActive == value) {
      return;
    }

    try {
      final repository = ref.read(riderRepositoryProvider);

      await repository.setRiderActive(rider, value: value);

      state = Rider(
        id: rider.id,
        isActive: value,
        alias: rider.alias,
        firstName: rider.firstName,
        lastName: rider.lastName,
        lastUpdated: DateTime.now(),
        profileImageUri: rider.profileImageUri,
      );

      ref.invalidate(riderListProvider);
    } catch (error) {
      // Errors are ignored.
    }
  }

  void setSelectedRider(Rider rider) {
    if (state != rider) {
      state = rider;
    }
  }
}
