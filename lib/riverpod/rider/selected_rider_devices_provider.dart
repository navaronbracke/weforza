import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';

/// This provider provides the devices of the selected rider.
final selectedRiderDevicesProvider = AsyncNotifierProvider(SelectedRiderDevicesNotifier.new);

class SelectedRiderDevicesNotifier extends AsyncNotifier<List<Device>> {
  @override
  FutureOr<List<Device>> build() {
    final id = ref.watch(selectedRiderProvider.select((r) => r?.id));

    if (id == null) {
      throw ArgumentError.notNull('id');
    }

    final repository = ref.watch(deviceRepositoryProvider);

    return repository.getOwnerDevices(id);
  }

  /// Add a device to the list of devices.
  Future<void> addDevice(DevicesCompanion model) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
    }

    final newDevice = await ref.read(deviceRepositoryProvider).addDevice(model);

    if (ref.mounted) {
      state = AsyncData([...?state.value, newDevice]);
    }
  }

  /// Delete the device at [index].
  Future<void> deleteDevice(int index) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError('The devices list was not loaded yet');
    }

    final List<Device> newDevices = [...?state.value];

    final device = newDevices[index];

    await ref.read(deviceRepositoryProvider).deleteDevice(device);

    if (!ref.mounted) {
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

    final updatedDevice = await ref.read(deviceRepositoryProvider).updateDevice(model);

    if (!ref.mounted) {
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
