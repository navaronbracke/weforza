import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/rider/serializable_rider.dart';

/// This class represents an [ImportRidersFileReader]
/// that handles the JSON format.
class ImportRidersJsonReader
    implements ImportRidersFileReader<Map<String, dynamic>> {
  @override
  Future<void> processChunk(
    Map<String, dynamic> chunk,
    List<SerializableRider> serializedRiders,
  ) async {
    bool active;
    String alias;
    List<String> deviceNames;
    String firstName;
    String lastName;
    DateTime lastUpdated;

    try {
      active = chunk['active'] as bool;
      alias = chunk['alias'] as String;
      deviceNames = (chunk['devices'] as List).cast<String>();
      firstName = chunk['firstName'] as String;
      lastName = chunk['lastName'] as String;
      lastUpdated = DateTime.parse(chunk['lastUpdated'] as String);

      final regex = Member.personNameAndAliasRegex;

      // If the first name, last name or alias is invalid, skip this chunk.
      if (!regex.hasMatch(firstName) ||
          !regex.hasMatch(lastName) ||
          alias.isNotEmpty && !regex.hasMatch(alias)) {
        return;
      }

      serializedRiders.add(
        SerializableRider(
          active: active,
          alias: alias,
          // Skip any invalid device names.
          devices: deviceNames.where(Device.deviceNameRegex.hasMatch).toSet(),
          firstName: firstName,
          lastName: lastName,
          lastUpdated: lastUpdated,
        ),
      );
    } catch (_) {
      // Invalid chunks are skipped.
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readFile(File file) async {
    final fileContent = await file.readAsString();

    try {
      // The supported formats are Map<String, dynamic> & List<dynamic>.
      final Object json = jsonDecode(fileContent);

      if (json is Map<String, dynamic>) {
        return (json['riders'] as List).cast<Map<String, dynamic>>();
      }

      // If the JSON format is a list instead of a map, try to cast it.
      if (json is List<dynamic>) {
        return json.cast<Map<String, dynamic>>();
      }

      throw const FormatException('Unexpected JSON format');
    } catch (e) {
      throw const DataSourceMalformedException(
        FileExtension.json,
        'The format of the input file is invalid',
      );
    }
  }
}
