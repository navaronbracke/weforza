import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/importable_member.dart';
import 'package:weforza/model/member.dart';

/// This interface defines a method to import a collection of members.
abstract class ImportMembersDao {
  /// Save the given [members].
  Future<void> saveMembersWithDevices(Iterable<ExportableMember> members);
}

/// The default implementation of [ImportMembersDao].
class ImportMembersDaoImpl implements ImportMembersDao {
  ImportMembersDaoImpl(this._database, DatabaseTables tables)
      : _deviceStore = tables.device,
        _memberStore = tables.member;

  /// A reference to the database.
  final Database _database;

  /// A reference to the [Device] store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  /// A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;

  /// Get all the existing devices.
  /// Returns a map of device names per owner uuid.
  Future<Map<String, Set<String>>> _getExistingDevices() async {
    final collection = <String, Set<String>>{};

    final records = await _deviceStore.find(_database);

    for (final record in records) {
      final Device device = Device.of(record.key, record.value);

      if (collection[device.ownerId] == null) {
        collection[device.ownerId] = <String>{device.name};
      } else {
        collection[device.ownerId]!.add(device.name);
      }
    }

    return collection;
  }

  /// Get the existing members.
  /// Returns a map of [Member]s mapped to [ImportableMemberKey]s.
  Future<Map<ImportableMemberKey, Member>> _getExistingMembers() async {
    final collection = <ImportableMemberKey, Member>{};

    final records = await _memberStore.find(_database);

    for (final record in records) {
      final key = ImportableMemberKey(
        firstName: record.value['firstname'],
        lastName: record.value['lastname'],
        alias: record.value['alias'],
      );

      if (collection[key] == null) {
        collection[key] = Member.of(record.key, record.value);
      }
    }

    return collection;
  }

  @override
  Future<void> saveMembersWithDevices(
    Iterable<ExportableMember> members,
  ) async {
    final existingDevicesFuture = _getExistingDevices();
    final existingMembersFuture = _getExistingMembers();

    final existingDevices = await existingDevicesFuture;
    final existingMembers = await existingMembersFuture;

    // The existing members that should be updated.
    final membersToUpdate = <ImportableMember>{};

    // The new members that should be added.
    final newMembers = <Member>{};

    // The new devices that should be added.
    final newDevices = <Device>{};

    const uuidGenerator = Uuid();

    for (final exportedMember in members) {
      final existingMember = existingMembers[exportedMember.importKey];

      if (existingMember != null) {
        final uuid = existingMember.uuid;

        // The exported member is newer than the existing member.
        // Adjust the last updated timestamp of the existing member,
        // and add the new devices of the exported member.
        if (exportedMember.lastUpdated.isAfter(existingMember.lastUpdated)) {
          membersToUpdate.add(
            ImportableMember(uuid: uuid, updatedOn: exportedMember.lastUpdated),
          );

          final memberExistingDevices = existingDevices[uuid] ?? {};

          for (final device in exportedMember.devices) {
            // Skip existing devices for this member.
            if (memberExistingDevices.contains(device)) {
              continue;
            }

            newDevices.add(
              Device(creationDate: DateTime.now(), name: device, ownerId: uuid),
            );
          }
        }
      } else {
        final newUuid = uuidGenerator.v4();

        // The member does not yet exist.
        // Add a new member and add the devices of this member.
        newMembers.add(
          Member(
            active: exportedMember.active,
            alias: exportedMember.alias,
            firstName: exportedMember.firstName,
            lastName: exportedMember.lastName,
            lastUpdated: exportedMember.lastUpdated,
            profileImageFilePath: null,
            uuid: newUuid,
          ),
        );

        for (final device in exportedMember.devices) {
          newDevices.add(
            Device(
              creationDate: DateTime.now(),
              name: device,
              ownerId: newUuid,
            ),
          );
        }
      }
    }

    await _database.transaction((txn) async {
      final updateMemberRecords = _memberStore.records(
        membersToUpdate.map((member) => member.uuid),
      );

      // Update the existing members.
      await updateMemberRecords.update(
        txn,
        membersToUpdate.map((member) => member.toMap()).toList(),
      );

      final addMemberRecords = _memberStore.records(
        newMembers.map((member) => member.uuid),
      );

      // Add the new members.
      await addMemberRecords.add(
        txn,
        newMembers.map((member) => member.toMap()).toList(),
      );

      final addDevicesRecords = _deviceStore.records(
        newDevices.map((device) => device.creationDate.toIso8601String()),
      );

      // Add the new devices.
      await addDevicesRecords.add(
        txn,
        newDevices.map((device) => device.toMap()).toList(),
      );
    });
  }
}
