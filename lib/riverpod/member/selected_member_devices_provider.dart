import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';

/// This provider provides the devices of the selected member.
final selectedMemberDevicesProvider = StateNotifierProvider((ref) {
  final selectedMember = ref.watch(selectedMemberProvider);
  final repository = ref.read(deviceRepositoryProvider);

  return SelectedMemberDevicesNotifier(
    repository: repository,
    uuid: selectedMember?.value.uuid,
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

  Future<Device> deleteDevice(int index) async {
    if (state is! AsyncData<List<Device>>) {
      throw StateError(
        'A device can only be deleted when the devices list was loaded',
      );
    }

    final newDevices = List.of(state.value!);

    final device = newDevices[index];

    await repository.removeDevice(device);

    newDevices.removeAt(index);

    state = AsyncData(newDevices);

    return device;
  }
}
