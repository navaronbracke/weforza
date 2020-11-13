
import 'dart:collection';

import 'package:sembast/sembast.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/model/importableMember.dart';
import 'package:weforza/model/member.dart';

abstract class IImportMembersDao {
  /// Save the given [ExportableMember]s to the database.
  /// [generateId] is used to generate UUID's for members that are inserted.
  Future<void> saveMembersWithDevices(Iterable<ExportableMember> members, String Function() generateId);
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
  Future<void> saveMembersWithDevices(Iterable<ExportableMember> members, String Function() generateId) async {
    // This Map holds the UUID's of the existing members, behind their combined first name, last name and alias.
    final Map<ImportableMember, String> existingMembers = HashMap();
    // This Set holds the existing devices.
    final Set<Device> existingDevices = Set();
    // This Set holds the devices that should be inserted.
    final Set<Device> devicesToImport = Set();
    // This Set holds the members that should be inserted.
    final Set<Member> membersToImport = Set();

    // Fetch the existing members & devices, in parallel.
    await Future.wait([
      _getExistingMembersAndMapFirstNameLastNameAndAliasToUuids(existingMembers),
      _getExistingDevicesAndCollectInGivenSet(existingDevices)
    ]);

    members.forEach((ExportableMember exportableMember) {
      final ImportableMember key = ImportableMember(
        firstName: exportableMember.firstName,
        lastName: exportableMember.lastName,
        alias: exportableMember.alias,
      );

      if(existingMembers[key] == null){
        // This is a new member.
        final Member member = Member(
          uuid: generateId(),
          firstname: exportableMember.firstName,
          lastname: exportableMember.lastName,
          alias: exportableMember.alias,
          isActiveMember: exportableMember.isActiveMember,
          profileImageFilePath: null,
        );

        // Add a Member object to membersToImport.
        membersToImport.add(member);
        // Add its devices to devicesToImport.
        devicesToImport.addAll(
            exportableMember.devices.map(
                    (deviceName) => Device(
                        ownerId: member.uuid,
                        name: deviceName,
                        creationDate: DateTime.now()
                    )
            )
        );
      }else{
        // This is an existing member.
        // Add the devices that don't exist in existingDevices,
        // to the devices to import collection.
        // Use the existing member uuid.
        final Iterable<Device> devicesToAdd = exportableMember.devices.map(
                (deviceName) => Device(
                ownerId: existingMembers[key],
                name: deviceName,
                creationDate: DateTime.now()
            )
        ).where((device) => existingDevices.add(device));

        devicesToImport.addAll(devicesToAdd);
      }
    });

    //Insert the records that passed all import checks.
    //Note that we generate our own keys to insert the records with.
    await _database.transaction((transaction) async {
      await _memberStore.records(
          membersToImport.map((member) => member.uuid)
      ).add(transaction, membersToImport.map((member) => member.toMap()).toList());

      await _deviceStore.records(
          devicesToImport.map((device) => device.creationDate.toIso8601String())
      ).add(transaction, devicesToImport.map((device)=> device.toMap()).toList());
    });
  }

  /// Fetch all the existing members and put their uuid's behind their combined first name, last name and alias.
  Future<void> _getExistingMembersAndMapFirstNameLastNameAndAliasToUuids(Map<ImportableMember, String> collection) async {
    final Iterable<RecordSnapshot<String, Map<String, dynamic>>> existingMembers = await _memberStore.find(_database);

    /// Map each record to a key - value in the collection.
    existingMembers.forEach((record) {
      collection[ImportableMember(
        firstName: record["firstname"] as String,
        lastName: record["lastname"] as String,
        alias: record["alias"] as String
      )] = record.key;
    });
  }

  /// Fetch all the existing devices and collect them in the given set.
  Future<void> _getExistingDevicesAndCollectInGivenSet(Set<Device> collection) async {
    final Iterable<Device> devices = await _deviceStore.find(_database).then(
            (records) => records.map((r)=> Device.of(r.key, r.value))
    );

    collection.addAll(devices);
  }
}