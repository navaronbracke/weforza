import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

/// This provider provides the device dao.
final deviceDaoProvider = Provider<DeviceDao>((ref) {
  final database = ref.read(databaseProvider);

  return DeviceDaoImpl(database.getDatabase());
});

/// This provider provides the export rides dao.
final exportRidesDaoProvider = Provider<ExportRidesDao>((ref) {
  final database = ref.read(databaseProvider);

  return ExportRidesDaoImpl(database.getDatabase());
});

/// This provider provides the import riders dao.
final importRidersDaoProvider = Provider<ImportRidersDao>((ref) {
  final database = ref.read(databaseProvider);

  return ImportRidersDaoImpl(database.getDatabase());
});

/// This provider provides the member dao.
final memberDaoProvider = Provider<RiderDao>((ref) {
  final database = ref.read(databaseProvider);

  return RiderDaoImpl(database.getDatabase());
});

/// This provider provides the ride dao.
final rideDaoProvider = Provider<RideDao>((ref) {
  final database = ref.read(databaseProvider);

  return RideDaoImpl(database.getDatabase());
});

/// This provider provides the application settings dao.
final settingsDaoProvider = Provider<SettingsDao>((ref) {
  final database = ref.read(databaseProvider);

  return SettingsDaoImpl(database.getDatabase());
});
