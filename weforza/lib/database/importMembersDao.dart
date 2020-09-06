
import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';

abstract class IImportMembersDao {
  Future<void> saveMembersWithDevices(Set<Member> members, Set<Device> devices);
}

class ImportMembersDao implements IImportMembersDao {
  ImportMembersDao(this._database, this._memberStore, this._deviceStore):
        assert(_database != null && _memberStore != null
            && _deviceStore != null
        );

  ImportMembersDao.withProvider(ApplicationDatabase provider): this(
    provider.getDatabase(),
    provider.memberStore,
    provider.deviceStore
  );

  ///A reference to the database, which is needed by the Store.
  final Database _database;
  ///A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;
  ///A reference to the [Device] store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  @override
  Future<void> saveMembersWithDevices(Set<Member> members, Set<Device> devices) async {
    //Get the existing members and devices and do a filter pass on the inputs.
    //This removes duplicates.
    final Set<Member> existingMembers = await _memberStore.find(_database).then(
            (records) => records.map((r) => Member.of(r.key, r.value)).toSet()
    );

    final Set<Device> existingDevices = await _deviceStore.find(_database).then(
            (records) => records.map((r)=> Device.of(r.key, r.value)).toSet()
    );

    members.removeWhere((member) => existingMembers.contains(member));
    devices.removeWhere((device) => existingDevices.contains(device));

    //Now we insert the remaining records.
    //Note that we generate our own keys to insert the records with.
    await _database.transaction((transaction) async {
      await _memberStore.records(
        members.map((member) => member.uuid)
      ).add(transaction, members.map((member) => member.toMap()).toList());

      await _deviceStore.records(
          devices.map((device) => device.creationDate.toIso8601String())
      ).add(transaction, devices.map((device)=> device.toMap()).toList());
    });
  }
}