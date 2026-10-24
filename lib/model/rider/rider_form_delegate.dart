import 'package:weforza/database/database.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/repository/rider_repository.dart';

/// This class represents the delegate for the rider form.
class RiderFormDelegate extends AsyncComputationDelegate<void> {
  new({required this._repository});

  final RiderRepository _repository;

  /// Add a new rider.
  /// The [whenComplete] function is called if the operation was successful.
  void addRider(RidersCompanion model, {required void Function() whenComplete}) async {
    if (!canStartComputation()) {
      return;
    }

    try {
      await _repository.addRider(model);

      if (mounted) {
        setDone(null);
        whenComplete();
      }
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }

  /// Edit an existing [Rider].
  /// When the rider was updated successfully,
  /// the [whenComplete] function is called with the updated rider.
  void editRider(RidersCompanion model, {required void Function(Rider updatedRider) whenComplete}) async {
    if (!canStartComputation()) {
      return;
    }

    try {
      final Rider rider = await _repository.updateRider(model);

      if (mounted) {
        setDone(null);
        whenComplete(rider);
      }
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}
