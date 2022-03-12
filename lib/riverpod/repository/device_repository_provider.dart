import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [DeviceRepository].
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepository(ref.read(deviceDaoProvider));
});
