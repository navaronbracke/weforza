
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';

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

  final Uuid _uuidGenerator = Uuid();

  @override
  Future<void> saveMembersWithDevices(List<Map<String, dynamic>> membersWithDevicesData) async {
    //Map the data to a map of Member + list of Device
    membersWithDevicesData = membersWithDevicesData.map((item){
      final String memberId = _uuidGenerator.v4();
      final List<String> deviceNames = item["devices"];

      return {
        "member": Member(memberId, item["firstName"], item["lastName"], item["phone"]),
        "devices": deviceNames.map((String deviceName) => Device(
          ownerId: memberId,
          creationDate: DateTime.now(),
          name: deviceName,
          type: DeviceType.UNKNOWN,
        )).toList(),
      };
    }).toList();

    //Collect all the members into a list
    List<Member> members = membersWithDevicesData
        .map((item) => item["member"] as Member).toList();

    //Collect all the devices into a list by flattening each list of "devices" in the items.
    List<Device> devices = membersWithDevicesData
        .map((item) => item["devices"] as List<Device>).expand((devices) => devices).toList();

    //Free the map from memory, we don't need it anymore
    membersWithDevicesData = null;

    await _database.transaction((transaction) async {
      //Filter out the existing items
      Set<Member> existingMembers = await _memberStore.find(transaction)
          .then((records) => records.map((r) => Member.of(r.key, r.value)).toSet());

      members = members.where((member) => !existingMembers.contains(member)).toList();

      //filter the duplicate uuid's
      Set<String> uuids = existingMembers.map((m) => m.uuid).toSet();
      //free up memory
      existingMembers = null;

      members = members.where((m) => !uuids.contains(m.uuid)).toList();
      //free up memory
      uuids = null;

      //Insert the unique items
      await _memberStore.records(
        //generate the keys
        members.map((member) => member.uuid))
          .add(transaction, members.map((member) => member.toMap()).toList());

      //free up memory
      members = null;

      //Filter out the existing items
      //We check for ownerID + deviceName, as type is not what makes a device unique
      Set<Device> existingDevices = await _deviceStore.find(transaction)
          .then((records) => records.map((r)=> Device.of(r.key, r.value)).toSet());

      devices = devices.where((device) => !existingDevices.contains(device)).toList();

      //free the memory for existing devices, we don't need it anymore
      existingDevices = null;

      //Insert the unique items
      await _deviceStore.records(
          //generate the record keys
          devices.map((device) => device.creationDate.toIso8601String())
      ).add(transaction, devices.map((device)=> device.toMap()).toList());
    });
  }
}