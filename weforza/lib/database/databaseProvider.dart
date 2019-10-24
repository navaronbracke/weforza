
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

  static Future initializeDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path,"weforza_database.db");
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

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
  static const String MEMBER_STORE_KEY = "member";

  final _memberStore = intMapStoreFactory.store(MEMBER_STORE_KEY);
  final Database _database;

  MemberDao(this._database):assert(_database != null);

  Future addMember(Member member) async {
    await _memberStore.add(_database, member.toMap());
  }

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

  Future<bool> checkIfExists(String firstname,String lastname, String phone) async {
    final finder = Finder(filter: Filter.and([
      Filter.equals("firstname", firstname),
      Filter.equals("lastname", lastname),
      Filter.equals("phone", phone)
    ]));
    return await _memberStore.findFirst(_database,finder: finder) != null;
  }

//edit /delete

}

///This class manages Rides in the database.
class RideDao {
  static const String RIDE_STORE_KEY = "ride";

  final _rideStore = intMapStoreFactory.store(RIDE_STORE_KEY);
  final Database _database;

  RideDao(this._database):assert(_database != null);

  Future addRide(Ride ride) async {
    await _rideStore.add(_database, ride.toMap());
  }

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

  //check if exists

  //edit/delete

}