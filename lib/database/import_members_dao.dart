import 'dart:collection';

import 'package:sembast/sembast.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/importable_member.dart';
import 'package:weforza/model/member.dart';

abstract class IImportMembersDao {
  /// Save the given [ExportableMember]s to the database.
  /// [generateId] is used to generate UUID's for members that are inserted.
  Future<void> saveMembersWithDevices(
      Iterable<ExportableMember> members, String Function() generateId);
}

class ImportMembersDao implements IImportMembersDao {
  ImportMembersDao(this._database, this._memberStore, this._deviceStore);

  ///A reference to the database, which is needed by the Store.
  final Database _database;

  ///A reference to the [Member] store.
  final StoreRef<String, Map<String, dynamic>> _memberStore;

  ///A reference to the [Device] store.
  final StoreRef<String, Map<String, dynamic>> _deviceStore;

  /// Get all the existing members
  /// and populate the given collection with the items.
  Future<void> _getExistingMembers(
      Map<ImportableMemberKey, Member> collection) async {
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
  }

  /// Get all the existing devices
  /// and populate the given collection with the items.
  Future<void> _getExistingDevices(Map<String, Set<String>> collection) async {
    final records = await _deviceStore.find(_database);

    for (final record in records) {
      final Device device = Device.of(record.key, record.value);

      if (collection[device.ownerId] == null) {
        collection[device.ownerId] = <String>{device.name};
      } else {
        collection[device.ownerId]!.add(device.name);
      }
    }
  }

  @override
  Future<void> saveMembersWithDevices(
      Iterable<ExportableMember> members, String Function() generateId) async {
    // This Map holds the existing members,
    // behind their combined first name, last name and alias.
    // With this collection we can check
    // if a given member is an existing one or not.
    // We can also retrieve properties of the existing member easily.
    final Map<ImportableMemberKey, Member> existingMembers = HashMap();
    // This Map holds the existing devices per member uuid.
    // We can only filter on the name of the device.
    final Map<String, Set<String>> existingDevices = HashMap();
    // This set holds the members that are scheduled for an update.
    final Set<ImportableMember> membersToUpdate = {};
    // This set holds the members that are scheduled for insertion.
    final Set<Member> newMembers = {};
    // This set holds the devices that are scheduled for insertion.
    final Set<Device> newDevices = {};

    await Future.wait<void>(<Future<void>>[
      _getExistingMembers(existingMembers),
      _getExistingDevices(existingDevices),
    ]);

    for (ExportableMember exportableMember in members) {
      final existingMember = existingMembers[ImportableMemberKey(
        firstName: exportableMember.firstName,
        lastName: exportableMember.lastName,
        alias: exportableMember.alias,
      )];

      if (existingMember != null) {
        // There is a more recent update to this member's devices.
        // Add the new devices and update the member's timestamp.
        if (exportableMember.lastUpdated.isAfter(existingMember.lastUpdated)) {
          membersToUpdate.add(ImportableMember(
            uuid: existingMember.uuid,
            // By importing this member, we 'sync' the updatedOn timestamp.
            updatedOn: exportableMember.lastUpdated,
          ));

          final Set<String> excludedDevicesForMember =
              existingDevices[existingMember.uuid] ?? {};

          // Add the devices for the member.
          newDevices.addAll(exportableMember.devices.where((String device) {
            // Filter out the existing devices for the given member.
            return !excludedDevicesForMember.contains(device);
          }).map((String device) {
            return Device(
              creationDate: DateTime.now(),
              name: device,
              ownerId: existingMember.uuid,
            );
          }));
        }
      } else {
        // Add the new member and all its devices.
        final newMember = Member(
          uuid: generateId(),
          firstname: exportableMember.firstName,
          lastname: exportableMember.lastName,
          alias: exportableMember.alias,
          isActiveMember: exportableMember.isActiveMember,
          lastUpdated: exportableMember.lastUpdated,
          profileImageFilePath: null,
        );
        newMembers.add(newMember);

        newDevices.addAll(exportableMember.devices.map((String device) {
          return Device(
            creationDate: DateTime.now(),
            name: device,
            ownerId: newMember.uuid,
          );
        }));
      }
    }

    // Apply the database transaction.
    // - update existing members
    // - add new members
    // - add new devices
    await _database.transaction((txn) async {
      // Update the existing members.
      await _memberStore
          .records(membersToUpdate.map((member) => member.uuid))
          .update(
              txn, membersToUpdate.map((member) => member.toMap()).toList());

      // Add the new members.
      await _memberStore
          .records(newMembers.map((member) => member.uuid))
          .add(txn, newMembers.map((member) => member.toMap()).toList());

      // Add the new devices.
      await _deviceStore
          .records(
              newDevices.map((device) => device.creationDate.toIso8601String()))
          .add(txn, newDevices.map((device) => device.toMap()).toList());
    });
  }
}
