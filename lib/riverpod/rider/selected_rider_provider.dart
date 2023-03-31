import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';

/// This provider manages the selected rider.
final selectedRiderProvider =
    StateNotifierProvider<SelectedRiderNotifier, Rider?>(
  SelectedRiderNotifier.new,
);

class SelectedRiderNotifier extends StateNotifier<Rider?> {
  SelectedRiderNotifier(this.ref) : super(null);

  final Ref ref;

  Future<void> deleteRider() async {
    final rider = state;

    if (rider == null) {
      throw ArgumentError.notNull('rider');
    }

    await ref.read(riderRepositoryProvider).deleteRider(rider.uuid);

    // Refresh the rider list, the collection has one item less.
    ref.invalidate(riderListProvider);

    // Remove the stale selected ride. Its attendees are now possibly out of date.
    ref.read(selectedRideProvider.notifier).setSelectedRide(null);
  }

  void setRiderActive({required bool value}) async {
    final rider = state;

    if (rider == null || rider.active == value) {
      return;
    }

    try {
      final repository = ref.read(riderRepositoryProvider);

      await repository.setRiderActive(rider.uuid, value: value);

      state = Rider(
        active: value,
        alias: rider.alias,
        firstName: rider.firstName,
        lastName: rider.lastName,
        lastUpdated: DateTime.now(),
        profileImageFilePath: rider.profileImageFilePath,
        uuid: rider.uuid,
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
