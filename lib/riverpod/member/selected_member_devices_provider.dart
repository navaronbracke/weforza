import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/device_payload.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';

/// This provider provides the devices of the selected member.
final selectedMemberDevicesProvider = StateNotifierProvider<
    SelectedMemberDevicesNotifier, AsyncValue<List<Device>>>((ref) {
  final selectedMember = ref.watch(selectedMemberProvider);
  final repository = ref.read(deviceRepositoryProvider);

  return SelectedMemberDevicesNotifier(
    repository: repository,
    uuid: selectedMember?.uuid,
  );
});

class SelectedMemberDevicesNotifier
    extends StateNotifier<AsyncValue<List<Device>>> {
  SelectedMemberDevicesNotifier({
    required this.repository,
    String? uuid,
  }) : super(const AsyncLoading()) {
    if (uuid == null) {
      state = AsyncError(ArgumentError.notNull('uuid'));

      return;
    }

    repository.getOwnerDevices(uuid).then((devices) {
      if (mounted) {
        state = AsyncData(devices);
      }
    }).catchError((error) {
      if (mounted) {
        state = AsyncError(error);
      }
    });
  }

  /// The repository that manages the devices.
  final DeviceRepository repository;

  /// Add a device to the list of devices.
  Future<void> addDevice(DevicePayload model) async {
    if (state is! AsyncData<List<Device>>) {
      return Future.error(StateError('The devices list was not loaded yet'));
    }

    final exists = await repository.deviceExists(model.name, model.ownerId);

    if (exists) {
      return Future.error(DeviceExistsException());
    }

    final device = Device(
      creationDate: DateTime.now(),
      name: model.name,
      ownerId: model.ownerId,
      type: model.type,
    );

    await repository.addDevice(device);

    if (!mounted) {
      return;
    }

    state = AsyncData([...state.value!, device]);
  }

  /// Delete the device at [index].
  Future<void> deleteDevice(int index) async {
    if (state is! AsyncData<List<Device>>) {
      return Future.error(StateError('The devices list was not loaded yet'));
    }

    final newDevices = List.of(state.value!);

    final device = newDevices[index];

    await repository.removeDevice(device);

    if (!mounted) {
      return;
    }

    newDevices.removeAt(index);

    state = AsyncData(newDevices);
  }

  /// Edit the given device.
  Future<void> editDevice(DevicePayload model) async {
    if (state is! AsyncData<List<Device>>) {
      return Future.error(StateError('The devices list was not loaded yet'));
    }

    final creationDate = model.creationDate;

    if (creationDate == null) {
      return Future.error(ArgumentError.notNull('creationDate'));
    }

    final exists = await repository.deviceExists(
      model.name,
      model.ownerId,
      creationDate,
    );

    if (exists) {
      return Future.error(DeviceExistsException());
    }

    final newDevice = Device(
      creationDate: creationDate,
      name: model.name,
      ownerId: model.ownerId,
      type: model.type,
    );

    await repository.updateDevice(newDevice);

    if (!mounted) {
      return;
    }

    final newDevices = List.of(state.value!);

    final index = newDevices.indexWhere(
      (d) => d.creationDate == model.creationDate,
    );

    if (index == -1) {
      return Future.error(ArgumentError.value(index));
    }

    newDevices[index] = newDevice;

    state = AsyncData(newDevices);
  }
}
