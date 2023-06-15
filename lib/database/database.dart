import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

import 'package:weforza/database/database_factory.dart';

/// This class represents the application database.
class ApplicationDatabase {
  ApplicationDatabase({this.databaseName = 'weforza_database.db'});

  /// The name of the database file.
  final String databaseName;

  /// The internal instance of the database.
  late Database _database;

  /// Get the database instance.
  Database getDatabase() => _database;

  /// Open the database using the provided [databaseFactory].
  Future<void> openDatabase(ApplicationDatabaseFactory databaseFactory) async {
    final databaseDirectory = await getApplicationSupportDirectory();
    final dbPath = join(databaseDirectory.path, databaseName);

    _database = await databaseFactory.factory.openDatabase(dbPath);
  }

  /// Close the database.
  void dispose() async => await _database.close();
}
