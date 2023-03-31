
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:path/path.dart';

///This class wraps a Sembast [Database] and datastore instances along with initializer and close methods.
class ApplicationDatabase {
  //The database filename.
  final String _databaseName = "weforza_database.db";

  ///The data store for [Member].
  final memberStore = stringMapStoreFactory.store("member");

  ///The data store for [Ride].
  final rideStore = stringMapStoreFactory.store("ride");

  ///The data store for [RideAttendee].
  final rideAttendeeStore = stringMapStoreFactory.store("rideAttendee");

  ///The data store for the member devices.
  final deviceStore = stringMapStoreFactory.store("device");

  ///The data store for general application settings.
  final settingsStore = stringMapStoreFactory.store("settings");

  //The internal instance of the database.
  Database _database;

  ///Get the database instance.
  Database getDatabase() => _database;

  ///Initialize the database.
  Future<void> createDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path,_databaseName);
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  void dispose() async =>  await _database?.close();
}