
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseFactory.dart';
import 'package:weforza/database/database_migration.dart';
import 'package:path/path.dart';

///This class wraps a Sembast [Database] and datastore instances along with initializer and close methods.
class ApplicationDatabase {
  ApplicationDatabase({
    this.databaseName = "weforza_database.db"
  });

  //The database filename.
  final String databaseName;

  // The internal instance of the database.
  // We can assume that it is created before it is used.
  late Database _database;

  /// Get the database instance.
  Database getDatabase() => _database;

  ///Initialize the database.
  Future<void> openDatabase(ApplicationDatabaseFactory databaseFactory, DatabaseMigration migration, {int version = 2}) async {
    final databaseDirectory = await getApplicationSupportDirectory();
    final dbPath = join(databaseDirectory.path, databaseName);

    // Move the database to the new directory if required.
    await migration.moveDatabase(dbPath, databaseFactory.fileSystem, databaseName);

    _database = await databaseFactory.factory.openDatabase(
      dbPath,
      version: version,
      onVersionChanged: migration.migrateDatabaseToUseEncryption,
    );
  }

  void dispose() async =>  await _database.close();
}