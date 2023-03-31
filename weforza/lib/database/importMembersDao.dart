
import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';

abstract class IImportMembersDao {
  Future<void> saveMembersWithDevices(List<Map<String,dynamic>> membersWithDevicesData);
}

class ImportMembersDao implements IImportMembersDao {
  ImportMembersDao(this._database): assert(_database != null);

  ///A reference to the database, which is needed by the Store.
  final Database _database;
  ///A reference to the [Member] store.
  final _memberStore = DatabaseProvider.memberStore;
  ///A reference to the [Device] store.
  final _deviceStore = DatabaseProvider.deviceStore;

  @override
  Future<void> saveMembersWithDevices(List<Map<String, dynamic>> membersWithDevicesData) async {
    print(membersWithDevicesData.first);//test for ios file reading

    //TODO save the list of maps to the database
    //TODO for each member
    //check if exists
    //if it does -> skip
    //else add to collection
    //save members -> after saving map the devices to pairs (member uuid / device name)
    //find all the device names

    //for each device/uuid -> save the ones that don't exist
  }
}