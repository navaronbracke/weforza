import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/device/device.dart';
import 'package:weforza/model/device/device_model.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';

/// This provider provides the devices of the selected rider.
final selectedRiderDevicesProvider = StateNotifierProvider<SelectedRiderDevicesNotifier, AsyncValue<List<Device>>>((
  ref,
) {
  final uuid = ref.watch(selectedRiderProvider.select((r) => r?.uuid));
  final repository = ref.read(deviceRepositoryProvider);

  return SelectedRiderDevicesNotifier(repository: repository, uuid: uuid);
});

class SelectedRiderDevicesNotifier extends StateNotifier<AsyncValue<List<Device>>> {
  SelectedRiderDevicesNotifier({required this.repository, String? uuid}) : super(const AsyncLoading()) {
    if (uuid == null) {
      state = AsyncError(ArgumentError.notNull('uuid'), StackTrace.current);

      return;
    }

    repository
        .getOwnerDevices(uuid)
        .then((devices) {
          if (mounted) {
            state = AsyncData(devices);
          }
        })
        .catchError((error) {
          if (mounted) {
            state = AsyncError(error, StackTrace.current);
          }
        });
  }

  /// The repository that manages the devices.
  final DeviceRepository repository;

  /// Add a device to the list of devices.
  Future<void> addDevice(DeviceModel model) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
    }

    final device = Device(creationDate: DateTime.now(), name: model.name, ownerId: model.ownerId, type: model.type);

    await repository.addDevice(device);

    if (!mounted) {
      return;
    }

    state = AsyncData([...state.value!, device]);
  }

  /// Delete the device at [index].
  Future<void> deleteDevice(int index) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
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
  Future<void> editDevice(DeviceModel model) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
    }

    final creationDate = model.creationDate;

    if (creationDate == null) {
      throw ArgumentError.notNull('creationDate');
    }

    final newDevice = Device(creationDate: creationDate, name: model.name, ownerId: model.ownerId, type: model.type);

    await repository.updateDevice(newDevice);

    if (!mounted) {
      return;
    }

    final newDevices = List.of(state.value!);

    final index = newDevices.indexWhere((d) => d.creationDate == model.creationDate);

    if (index == -1) {
      throw ArgumentError.value(index);
    }

    newDevices[index] = newDevice;

    state = AsyncData(newDevices);
  }
}
