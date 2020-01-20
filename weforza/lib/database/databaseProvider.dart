
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:path/path.dart';

///This class provides a Sembast Database.
class DatabaseProvider {
  ///The internal database instance.
  static Database _database;

  ///The data store for [Member].
  static final memberStore = stringMapStoreFactory.store("member");
  ///The data store for [Ride].
  static final rideStore = stringMapStoreFactory.store("ride");
  ///The data store for [RideAttendee].
  static final rideAttendeeStore = stringMapStoreFactory.store("rideAttendee");
  ///The data store for the member devices.
  static final deviceStore = stringMapStoreFactory.store("device");

  ///Get the database instance.
  static Database getDatabase() => _database;

  ///Initialize the database.
  static Future initializeDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path,"weforza_database.db");
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  ///Dispose of the database.
  static Future dispose() async {
    if(_database == null) throw Exception("Database Not Initialized");

    await _database.close();
  }
}