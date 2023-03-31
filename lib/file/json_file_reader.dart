import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/import_members_file_reader.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/member.dart';

/// This class represents a JSON file reader.
class JsonFileReader implements ImportMembersFileReader<Map<String, dynamic>> {
  @override
  Future<void> processData(
    Map<String, dynamic> data,
    List<ExportableMember> collection,
  ) async {
    String firstName;
    String lastName;
    String alias;
    bool isActive;
    List<String> deviceNames;
    DateTime lastUpdated;

    try {
      firstName = data['firstName'] as String;
      lastName = data['lastName'] as String;
      alias = data['alias'] as String;
      isActive = data['active'] as bool;
      deviceNames = (data['devices'] as List).cast<String>();
      lastUpdated = DateTime.parse(data['lastUpdated'] as String);

      // The first name, last name or alias are not suitable for a member.
      if (!Member.personNameAndAliasRegex.hasMatch(firstName) ||
          !Member.personNameAndAliasRegex.hasMatch(lastName) ||
          alias.isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(alias)) {
        return;
      }

      collection.add(ExportableMember(
        firstName: firstName,
        lastName: lastName,
        alias: alias,
        active: isActive,
        devices: deviceNames.where(Device.deviceNameRegex.hasMatch).toSet(),
        lastUpdated: lastUpdated,
      ));
    } catch (e) {
      // Invalid items are skipped.
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readFile(File file) async {
    try {
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());

      return (json['riders'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return Future.error(JsonFormatIncompatibleException());
    }
  }
}
