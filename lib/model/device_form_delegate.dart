import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/device_payload.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';

/// This class represents the delegate for the add / edit device form.
class DeviceFormDelegate {
  DeviceFormDelegate(this.ref);

  final WidgetRef ref;

  /// This controller manages a submit flag.
  /// If the current value is true, the delegate is submitting the form.
  /// If the current value is false, the delegate is idle.
  /// If the current value is an error, the submit failed.
  ///
  /// Once the delegate enters the submitting state,
  /// it does not exit said state upon successful completion.
  /// It is up to the caller of [addDevice] or [editDevice]
  /// to handle the result of the future.
  final _submitController = BehaviorSubject.seeded(false);

  bool get isSubmitting => _submitController.value;

  Stream<bool> get isSubmittingStream => _submitController;

  Future<void> addDevice(DevicePayload model) async {
    _submitController.add(true);

    try {
      final repository = ref.read(deviceRepositoryProvider);

      final exists = await repository.deviceExists(model.name, model.ownerId);

      if (exists) {
        throw DeviceExistsException();
      }

      final device = Device(
        creationDate: DateTime.now(),
        name: model.name,
        ownerId: model.ownerId,
        type: model.type,
      );

      await repository.addDevice(device);

      ref.refresh(selectedMemberDevicesProvider);
    } catch (error) {
      _submitController.addError(error);

      rethrow;
    }
  }

  Future<Device> editDevice(DevicePayload model) async {
    _submitController.add(true);

    try {
      final creationDate = model.creationDate;

      if (creationDate == null) {
        throw ArgumentError.notNull('creationDate');
      }

      final repository = ref.read(deviceRepositoryProvider);

      final exists = await repository.deviceExists(
        model.name,
        model.ownerId,
        creationDate,
      );

      if (exists) {
        throw DeviceExistsException();
      }

      final newDevice = Device(
        creationDate: creationDate,
        name: model.name,
        ownerId: model.ownerId,
        type: model.type,
      );

      await repository.updateDevice(newDevice);

      return newDevice;
    } catch (error) {
      _submitController.addError(error);

      rethrow;
    }
  }

  void resetSubmit(String? _) {
    if (!_submitController.isClosed && _submitController.hasError) {
      _submitController.add(false);
    }
  }

  void dispose() {
    _submitController.close();
  }
}
