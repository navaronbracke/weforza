import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_members_dao.dart';
import 'package:weforza/database/member_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

/// This provider provides the device dao.
final deviceDaoProvider = Provider<IDeviceDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return DeviceDao(
    database.getDatabase(),
    databaseTables.device,
    databaseTables.member,
  );
});

/// This provider provides the export rides dao.
final exportRidesDaoProvider = Provider<IExportRidesDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return ExportRidesDao(
    database.getDatabase(),
    databaseTables.member,
    databaseTables.ride,
    databaseTables.rideAttendee,
  );
});

/// This provider provides the import members dao.
final importMembersDaoProvider = Provider<IImportMembersDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return ImportMembersDao(
    database.getDatabase(),
    databaseTables.member,
    databaseTables.device,
  );
});

/// This provider provides the member dao.
final memberDaoProvider = Provider<IMemberDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return MemberDao(
    database.getDatabase(),
    databaseTables.member,
    databaseTables.rideAttendee,
    databaseTables.device,
  );
});

/// This provider provides the ride dao.
final rideDaoProvider = Provider<IRideDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return RideDao(
    database.getDatabase(),
    databaseTables.member,
    databaseTables.ride,
    databaseTables.rideAttendee,
  );
});

/// This provider provides the application settings dao.
final settingsDaoProvider = Provider<ISettingsDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return SettingsDao(database.getDatabase(), databaseTables.settings);
});
