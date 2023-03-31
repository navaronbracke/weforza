import 'dart:convert';
import 'dart:io';

import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/model/device/device.dart';
import 'package:weforza/model/rider/rider.dart';
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
    try {
      final alias = chunk['alias'] as String? ?? '';
      final firstName = chunk['firstName'] as String;
      final lastName = chunk['lastName'] as String;

      final regex = Rider.personNameAndAliasRegex;

      // If the first name, last name or alias is invalid, skip this chunk.
      if (!regex.hasMatch(firstName) ||
          !regex.hasMatch(lastName) ||
          alias.isNotEmpty && !regex.hasMatch(alias)) {
        return;
      }

      final lastUpdated = DateTime.tryParse(
        chunk['lastUpdated'] as String? ?? '',
      );

      final devices = (chunk['devices'] as List?)?.cast<String>() ?? [];

      serializedRiders.add(
        SerializableRider(
          active: chunk['active'] as bool? ?? false,
          alias: alias,
          // Skip any invalid device names.
          devices: devices.where(Device.deviceNameRegex.hasMatch).toSet(),
          firstName: firstName,
          lastName: lastName,
          lastUpdated: lastUpdated ?? DateTime.now(),
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
      throw const FormatException('The format of the input file is invalid');
    }
  }
}
