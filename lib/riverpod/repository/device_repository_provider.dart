import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) => DeviceRepository(ref.watch(databaseProvider)));
