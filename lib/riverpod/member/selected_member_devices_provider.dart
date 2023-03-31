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

class SelectedMemberDevicesNotifier extends StateNotifier<List<Device>> {
  SelectedMemberDevicesNotifier({
    required this.repository,
    String? uuid,
  }) : super([]) {
    if (uuid == null) {
      future = Future.error(ArgumentError.notNull('uuid'));

      return;
    }

    future = repository.getOwnerDevices(uuid).then((devices) {
      if (!mounted) {
        return;
      }

      state = devices;
    });
  }

  /// The repository that manages the devices.
  final DeviceRepository repository;

  /// The future that represents the loading of the devices.
  ///
  /// When this future completes, [state] contains the devices.
  late final Future<void> future;

  Future<Device> deleteDevice(int index) async {
    final newDevices = List.of(state);

    final device = newDevices[index];

    await repository.removeDevice(device);

    newDevices.removeAt(index);

    state = newDevices;

    return device;
  }
}
