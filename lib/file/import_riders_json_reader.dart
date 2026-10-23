import 'dart:convert';

import 'package:file/file.dart' as fs;
import 'package:weforza/database/devices.dart';
import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/model/export/exportable_rider.dart';

/// This class represents an [ImportRidersFileReader]
/// that handles the JSON format.
class ImportRidersJsonReader implements ImportRidersFileReader<Map<String, Object?>> {
  @override
  Future<void> processChunk(Map<String, Object?> chunk, List<ExportableRider> exportedRiders) async {
    try {
      if (chunk
          case {
            'alias': final String? alias,
            'devices': final List<Object?>? devicesList,
            'firstName': final String firstName,
            'isActive': final Object? isActive,
            'lastName': final String lastName,
            'lastUpdated': final String lastUpdatedAsString,
          }
          when lastUpdatedAsString.isNotEmpty) {
        if (!ImportRidersFileReader.nameIsValid(firstName: firstName, lastName: lastName, alias: alias ?? '')) {
          return;
        }

        final lastUpdated = DateTime.tryParse(lastUpdatedAsString);

        if (lastUpdated == null) {
          return;
        }

        exportedRiders.add(
          ExportableRider(
            alias: alias ?? '',
            firstName: firstName,
            lastName: lastName,
            isActive: ImportRidersFileReader.parseActiveValue(isActive),
            lastUpdated: lastUpdated,
            devices: {
              for (final device in devicesList ?? const {})
                if (device is String && Devices.deviceNameRegex.hasMatch(device)) device,
            },
          ),
        );
      }
    } catch (_) {
      // Invalid chunks are skipped.
    }
  }

  @override
  Future<List<Map<String, Object?>>> readFile(fs.File file) async {
    final fileContent = await file.readAsString();

    try {
      final Object json = jsonDecode(fileContent);

      // Allow the single key in the JSON to have any name, since the key could be upper case, snake case, etc.
      if (json case Map<Object?, Object?>(:final entries) when entries.length == 1) {
        if (entries.first.value case final List<Object?> riders) {
          return riders.cast<Map<String, Object?>>();
        }
      }

      // If the JSON format is a list instead of a map, try to cast it.
      if (json is List<Object?>) {
        return json.cast<Map<String, Object?>>();
      }

      throw const FormatException('Unexpected JSON format');
    } catch (e) {
      throw const FormatException('The format of the input file is invalid');
    }
  }
}
