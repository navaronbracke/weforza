
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/model/RideAttendee.dart';
import 'package:weforza/model/attendee.dart';
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

///This class manages Rides in the database.
class RideDao {
  RideDao(this._database): assert(_database != null);

  ///The Store for this object.
  final _rideStore = DatabaseProvider.rideStore;
  ///A reference to the database for this object.
  final Database _database;

  ///Add a given set of Rides.
  Future addRides(List<Ride> rides) async {
    assert(rides != null && rides.isNotEmpty);
    //TODO bulk insert with key
  }

  ///Get all stored Rides.
  Future<List<Ride>> getRides() async {
    final finder = Finder(
      sortOrders: [SortOrder("date",false)]
    );

    final records = await _rideStore.find(_database,finder: finder);

    return records.map((record)=> Ride.fromMap(DateTime.parse(record.key),record.value)).toList();
  }

  ///Edit a given Ride.
  Future editRide(Ride ride) async {
    assert(ride != null);
    final finder = Finder(
      filter: Filter.byKey(ride.date),
    );

    await _rideStore.update(_database,ride.toMap(),finder: finder);
  }

  Future deleteRide(int id) async {
    final finder = Finder(
      filter: Filter.byKey(id)
    );
    await _rideStore.delete(_database,finder: finder);
  }

  Future removeAttendeeFromRides(Attendee attendee) async {
    assert(attendee != null);

    final records = await _rideStore.find(_database,finder: Finder());
    if(records.isEmpty) return;

    //Update the rides if they have the attendee
    List<Map<String,dynamic>> updatedRecords = records.map((record) {
      final ride = Ride.fromMap(record.value);
      if(ride.attendees.contains(attendee)){
        ride.attendees.remove(attendee);
      }
      return ride.toMap();
    }).toList();

    //Save
    await _database.transaction((transaction) async {
      List<Future> futures = List();
      updatedRecords.forEach((record){
        futures.add(_rideStore.update(transaction,record));
      });
      await Future.wait(futures);
    });
  }

}