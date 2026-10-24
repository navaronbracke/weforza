import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/database/devices.dart';
import 'package:weforza/database/excluded_terms.dart';
import 'package:weforza/database/ride_attendees.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/database/rides.dart';
import 'package:weforza/database/utils/device_type_converter.dart';
import 'package:weforza/database/utils/tiny_int_sql_type.dart';
import 'package:weforza/database/utils/uri_converter.dart';
import 'package:weforza/model/device/device_type.dart';

part 'database.g.dart';

/// The database for the application.
///
/// The definition is generated from the tables listed in `tables`.
@DriftDatabase(tables: [Riders, Rides, RideAttendees, Devices, ExcludedTerms])
class WeForzaDatabase extends _$WeForzaDatabase {
  /// Create a new [WeForzaDatabase] instance, on the local file system.
  new() : super(_openConnection());

  /// Create a new [WeForzaDatabase] instance for testing purposes.
  /// This uses an in-memory database.
  ///
  /// The option `DatabaseConnection.closeStreamsSynchronously` is set to true,
  /// to avoid streams dangling in tests.
  new memory() : super(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));

  /// The name of the database file.
  ///
  /// The actual database file will be a `.sqlite` file, i.e. `weforza_database.sqlite`.
  static const String databaseName = 'weforza_database';

  /// Open a new database in the application support directory.
  ///
  /// Returns a [QueryExecutor] that can be used by the database.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: databaseName,
      native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
    );
  }

  @override
  int get schemaVersion => 1;
}
