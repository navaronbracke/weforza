import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';

/// This provider provides the devices of the selected rider.
final selectedRiderDevicesProvider = StateNotifierProvider<SelectedRiderDevicesNotifier, AsyncValue<List<Device>>>((
  ref,
) {
  final id = ref.watch(selectedRiderProvider.select((r) => r?.id));
  final repository = ref.read(deviceRepositoryProvider);

  return SelectedRiderDevicesNotifier(repository: repository, id: id);
});

class SelectedRiderDevicesNotifier extends StateNotifier<AsyncValue<List<Device>>> {
  new({required this.repository, int? id}) : super(const AsyncLoading()) {
    if (id == null) {
      state = AsyncError(ArgumentError.notNull('id'), StackTrace.current);

      return;
    }

    repository
        .getOwnerDevices(id)
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
  Future<void> addDevice(DevicesCompanion model) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
    }

    final newDevice = await repository.addDevice(model);

    if (!mounted) {
      return;
    }

    state = AsyncData([...?state.value, newDevice]);
  }

  /// Delete the device at [index].
  Future<void> deleteDevice(int index) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
    }

    final List<Device> newDevices = [...?state.value];

    final device = newDevices[index];

    await repository.deleteDevice(device);

    if (!mounted) {
      return;
    }

    newDevices.removeAt(index);

    state = AsyncData(newDevices);
  }

  /// Edit the given device.
  Future<void> editDevice(DevicesCompanion model) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
    }

    final updatedDevice = await repository.updateDevice(model);

    if (!mounted) {
      return;
    }

    final newDevices = [...?state.value];

    final index = newDevices.indexWhere((d) => d.id == updatedDevice.id);

    if (index == -1) {
      throw ArgumentError.value(index);
    }

    newDevices[index] = updatedDevice;

    state = AsyncData(newDevices);
  }
}
