import 'package:weforza/extensions/artificial_delay_mixin.dart';
import 'package:weforza/model/device_payload.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';

/// This class represents the delegate for the add / edit device form.
class DeviceFormDelegate with ArtificialDelay {
  DeviceFormDelegate({required this.notifier});

  /// The notifier that handles adding and editing devices.
  final SelectedMemberDevicesNotifier notifier;

  /// Add a new device.
  Future<void> addDevice(DevicePayload model) async {
    // Allow the event loop some time to add an error handler.
    // When the database has almost no data, this future completes even before
    // the event loop could schedule a new frame,
    // which results in an unhandled exception in the FutureBuilder.
    //
    // This also gives the loading indicator some time to appear properly.
    await waitForDelay();
    await notifier.addDevice(model);
  }

  /// Edit an existing device.
  Future<void> editDevice(DevicePayload model) async {
    // Allow the event loop some time to add an error handler.
    // When the database has almost no data, this future completes even before
    // the event loop could schedule a new frame,
    // which results in an unhandled exception in the FutureBuilder.
    //
    // This also gives the loading indicator some time to appear properly.
    await waitForDelay();
    await notifier.editDevice(model);
  }
}
