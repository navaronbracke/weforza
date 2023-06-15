import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/database/settings_dao.dart';
import 'package:weforza/riverpod/database/database_provider.dart';

/// This provider provides the device dao.
final deviceDaoProvider = Provider<DeviceDao>((ref) => ref.read(databaseProvider).deviceDao);

/// This provider provides the export rides dao.
final exportRidesDaoProvider = Provider<ExportRidesDao>((ref) => ref.read(databaseProvider).exportRidesDao);

/// This provider provides the import riders dao.
final importRidersDaoProvider = Provider<ImportRidersDao>((ref) => ref.read(databaseProvider).importRidersDao);

/// This provider provides the rider dao.
final riderDaoProvider = Provider<RiderDao>((ref) => ref.read(databaseProvider).riderDao);

/// This provider provides the ride dao.
final rideDaoProvider = Provider<RideDao>((ref) => ref.read(databaseProvider).rideDao);

/// This provider provides the application settings dao.
final settingsDaoProvider = Provider<SettingsDao>((ref) => ref.read(databaseProvider).settingsDao);
