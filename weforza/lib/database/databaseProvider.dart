
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:path/path.dart';

///This class provides an interface for interacting with the local database.
abstract class IDatabaseProvider {

  Future<void> initializeDatabase();

  Future<void> dispose();

  Future<void> addMember(Member member);

  Future<List<Member>> getMembers();

  Future<void> addRide(Ride ride);

  Future<List<Ride>> getRides();

  //read / write members and rides
}

///This class provides a Database.
class DatabaseProvider implements IDatabaseProvider {
  ///Database store keys
  static const String MEMBER_STORE_KEY = "member";
  static const String RIDE_STORE_KEY = "ride";

  Database _database;

  final _memberStore = intMapStoreFactory.store(MEMBER_STORE_KEY);
  final _rideStore = intMapStoreFactory.store(RIDE_STORE_KEY);



  @override
  Future<void> initializeDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path,"weforza_database.db");
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  @override
  Future<void> dispose() async {
    if(_database != null)
    {
      await _database.close();
    }
  }

  @override
  Future<void> addMember(Member member) async {
    if(_database != null){
      await _memberStore.add(_database, member.toMap());
    }
  }

  @override
  Future<void> addRide(Ride ride) async {
    if(_database != null){
      await _rideStore.add(_database, ride.toMap());
    }
  }

  @override
  Future<List<Member>> getMembers() async {
    if(_database != null){
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
    return null;
  }

  @override
  Future<List<Ride>> getRides() async {
    if(_database != null){
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
    return null;
  }



}

///This class provides a test Database.
class TestDatabaseProvider implements IDatabaseProvider {

  //list of members

  //list of rides

  @override
  Future<void> initializeDatabase() async {}

  @override
  Future<void> dispose() async {}

}