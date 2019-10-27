
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:path/path.dart';

///This class provides a Sembast Database.
class DatabaseProvider {
  static Database _database;

  static Database getDatabase() => _database;

  ///Initialize the database.
  static Future initializeDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path,"weforza_database.db");
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  ///Dispose of the database.
  static Future dispose() async {
    if(_database != null)
    {
      await _database.close();
    }
    throw Exception("Database Not Initialized");
  }
}

///This class manages Members in the database.
class MemberDao {
  ///The key for this Dao's Store object.
  static const String MEMBER_STORE_KEY = "member";

  ///The Store, which manipulates the database.
  final _memberStore = intMapStoreFactory.store(MEMBER_STORE_KEY);
  ///A reference to the database, which is needed by the Store.
  final Database _database;

  MemberDao(this._database):assert(_database != null);

  ///Add [member] to the database.
  Future addMember(Member member) async {
    assert(member != null);
    await _memberStore.add(_database, member.toMap());
  }

  ///Get all stored members.
  Future<List<Member>> getMembers() async {
    final finder = Finder(
        sortOrders: [SortOrder("firstname"),SortOrder("lastname")]
    );

    final records = await _memberStore.find(_database,finder: finder);

    return records.map((record){
      final member = Member.fromMap(record.value);
      member.id = record.key;
      return member;
    }).toList();
  }

  ///Check if a given member exists.
  Future<bool> checkIfExists(String firstname,String lastname, String phone) async {
    assert(firstname != null && lastname != null && phone != null);
    final finder = Finder(filter: Filter.and([
      Filter.equals("firstname", firstname),
      Filter.equals("lastname", lastname),
      Filter.equals("phone", phone)
    ]));
    return await _memberStore.findFirst(_database,finder: finder) != null;
  }

  ///Delete a Member with the given key.
  Future deleteMember(int id) async {
    assert(id != null);
    final finder = Finder(
      filter: Filter.byKey(id),
    );

    await _memberStore.delete(_database,finder: finder);
  }

  ///Edit a given member.
  Future editMember(Member member) async {
    assert(member != null);
    final finder = Finder(
      filter: Filter.byKey(member.id),
    );

    await _memberStore.update(_database,member.toMap(),finder: finder);
  }

}

///This class manages Rides in the database.
class RideDao {
  ///The Store key for this object.
  static const String RIDE_STORE_KEY = "ride";

  ///The Store for this object.
  final _rideStore = intMapStoreFactory.store(RIDE_STORE_KEY);
  ///A reference to the database for this object.
  final Database _database;

  RideDao(this._database):assert(_database != null);

  ///Add a given set of Rides.
  Future addRides(List<Ride> rides) async {
    assert(rides != null && rides.isNotEmpty);
    await _rideStore.addAll(_database, rides.map((ride) => ride.toMap()));
  }

  ///Get all stored Rides.
  Future<List<Ride>> getRides() async {
    final finder = Finder();

    final records = await _rideStore.find(_database,finder:finder);

    final list = records.map((record){
      final ride = Ride.fromMap(record.value);
      ride.id = record.key;
      return ride;
    }).toList();
    list.sort((element1,element2)=> element1.date.compareTo(element2.date));

    return list;
  }

  ///Edit a given Ride.
  Future editRide(Ride ride) async {
    assert(ride != null);
    final finder = Finder(
      filter: Filter.byKey(ride.id),
    );

    await _rideStore.update(_database,ride.toMap(),finder: finder);
  }

  ///Delete a Ride with the given key.
  Future deleteRide(int id) async {
    assert(id != null);
    final finder = Finder(
      filter: Filter.byKey(id),
    );

    await _rideStore.delete(_database,finder: finder);
  }

}