import 'package:rxdart/rxdart.dart';
import 'package:weforza/model/device_payload.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';

/// This class represents the delegate for the add / edit device form.
class DeviceFormDelegate {
  DeviceFormDelegate({required this.notifier});

  /// The notifier that handles adding and editing devices.
  final SelectedMemberDevicesNotifier notifier;

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
      await notifier.addDevice(model);
    } catch (error) {
      _submitController.addError(error);

      rethrow;
    }
  }

  Future<void> editDevice(DevicePayload model) async {
    _submitController.add(true);

    try {
      await notifier.editDevice(model);
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
