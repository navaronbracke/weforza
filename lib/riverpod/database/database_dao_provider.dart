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
final deviceDaoProvider = Provider<DeviceDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return DeviceDaoImpl(database.getDatabase(), databaseTables);
});

/// This provider provides the export rides dao.
final exportRidesDaoProvider = Provider<ExportRidesDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return ExportRidesDaoImpl(database.getDatabase(), databaseTables);
});

/// This provider provides the import members dao.
final importMembersDaoProvider = Provider<ImportMembersDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return ImportMembersDaoImpl(database.getDatabase(), databaseTables);
});

/// This provider provides the member dao.
final memberDaoProvider = Provider<MemberDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return MemberDaoImpl(database.getDatabase(), databaseTables);
});

/// This provider provides the ride dao.
final rideDaoProvider = Provider<RideDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return RideDaoImpl(database.getDatabase(), databaseTables);
});

/// This provider provides the application settings dao.
final settingsDaoProvider = Provider<SettingsDao>((ref) {
  final database = ref.read(databaseProvider);
  final databaseTables = ref.read(databaseTableProvider);

  return SettingsDaoImpl(database.getDatabase(), databaseTables);
});
