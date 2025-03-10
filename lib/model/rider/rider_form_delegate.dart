import 'package:uuid/uuid.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/rider_model.dart';
import 'package:weforza/repository/rider_repository.dart';

/// This class represents the delegate for the rider form.
class RiderFormDelegate extends AsyncComputationDelegate<void> {
  RiderFormDelegate({required this.repository});

  final RiderRepository repository;

  /// Add a new rider.
  /// The [whenComplete] function is called if the operation was successful.
  void addRider(RiderModel model, {required void Function() whenComplete}) async {
    if (!canStartComputation()) {
      return;
    }

    final rider = Rider(
      active: true,
      alias: model.alias,
      firstName: model.firstName,
      lastName: model.lastName,
      lastUpdated: DateTime.now(),
      profileImage: model.profileImage,
      uuid: const Uuid().v4(),
    );

    try {
      await repository.addRider(rider);

      if (mounted) {
        setDone(null);
        whenComplete();
      }
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }

  /// Edit an existing rider.
  /// When the rider was updated successfully,
  /// the [whenComplete] function is called with the updated rider.
  void editRider(RiderModel model, {required void Function(Rider updatedRider) whenComplete}) async {
    if (!canStartComputation()) {
      return;
    }

    try {
      final uuid = model.uuid;

      if (uuid == null) {
        throw ArgumentError.notNull('uuid');
      }

      final updatedRider = Rider(
        active: model.active,
        alias: model.alias,
        firstName: model.firstName,
        lastName: model.lastName,
        lastUpdated: DateTime.now(),
        profileImage: model.profileImage,
        uuid: uuid,
      );

      await repository.updateRider(updatedRider);

      if (mounted) {
        setDone(null);
        whenComplete(updatedRider);
      }
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}
