import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_members_dao.dart';
import 'package:weforza/database/member_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/riverpod/database/database_provider.dart';
import 'package:weforza/riverpod/database/database_store_provider.dart';

/// This provider provides the device dao.
final deviceDaoProvider = Provider<IDeviceDao>((ref) {
  final database = ref.read(databaseProvider);

  return DeviceDao(
    database.getDatabase(),
    ref.read(deviceStoreProvider),
    ref.read(memberStoreProvider),
  );
});

/// This provider provides the export rides dao.
final exportRidesDaoProvider = Provider<IExportRidesDao>((ref) {
  final database = ref.read(databaseProvider);

  return ExportRidesDao(
    database.getDatabase(),
    ref.read(memberStoreProvider),
    ref.read(rideStoreProvider),
    ref.read(rideAttendeeStoreProvider),
  );
});

/// This provider provides the import members dao.
final importMembersDaoProvider = Provider<IImportMembersDao>((ref) {
  final database = ref.read(databaseProvider);

  return ImportMembersDao(
    database.getDatabase(),
    ref.read(memberStoreProvider),
    ref.read(deviceStoreProvider),
  );
});

/// This provider provides the member dao.
final memberDaoProvider = Provider<IMemberDao>((ref) {
  final database = ref.read(databaseProvider);

  return MemberDao(
    database.getDatabase(),
    ref.read(memberStoreProvider),
    ref.read(rideAttendeeStoreProvider),
    ref.read(deviceStoreProvider),
  );
});

/// This provider provides the ride dao.
final rideDaoProvider = Provider<IRideDao>((ref) {
  final database = ref.read(databaseProvider);

  return RideDao(
    database.getDatabase(),
    ref.read(memberStoreProvider),
    ref.read(rideStoreProvider),
    ref.read(rideAttendeeStoreProvider),
  );
});

/// This provider provides the application settings dao.
final settingsDaoProvider = Provider<ISettingsDao>((ref) {
  final database = ref.read(databaseProvider);

  return SettingsDao(
    database.getDatabase(),
    ref.read(settingsStoreProvider),
    ref.read(rideStoreProvider),
  );
});
