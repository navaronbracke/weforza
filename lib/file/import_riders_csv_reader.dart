import 'dart:convert';

import 'package:file/file.dart' as fs;
import 'package:weforza/database/devices.dart';
import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/model/export/exportable_rider.dart';

/// This class represents an [ImportRidersFileReader]
/// that handles the CSV format.
class ImportRidersCsvReader implements ImportRidersFileReader<String> {
  /// The default constructor.
  ///
  /// The cell [delimiter] defaults to a comma.
  factory({String delimiter = ','}) {
    // A single cell can contain unicode letters, dashes and hyphens.
    const cellMatcher = r'([\p{L}_-])+';

    final regexBuilder = StringBuffer('^'); // Match the start of the string.

    for (int i = 0; i < requiredHeaderColumns; i++) {
      // Match each required cell in the header.
      regexBuilder.write(cellMatcher);

      // Each cell, except the last cell, should contain the delimiter.
      if (i != requiredHeaderColumns - 1) {
        regexBuilder.write(delimiter);
      }
    }

    // Everything after the last cell is ignored.
    regexBuilder.write(r'(.*)$');

    return ImportRidersCsvReader._(headerRegex: RegExp(regexBuilder.toString(), unicode: true));
  }

  /// The private constructor.
  new _({required this.headerRegex});

  /// The minimum expected amount of columns for a valid header line.
  ///
  /// A header line is only valid if it contains the following columns:
  /// Column 1: First Name
  /// Column 2: Last Name
  /// Column 3: Alias (This cell can be empty)
  /// Column 4: Active
  /// Column 5: Last Updated On
  /// Column 6: Devices
  static const requiredHeaderColumns = 6;

  /// The regular expression that validates the first line in the input file.
  final RegExp headerRegex;

  @override
  Future<void> processChunk(String chunk, List<ExportableRider> exportedRiders) async {
    final List<String> cells = chunk.split(',');

    // The cells follow the specific order
    //
    // `firstName,lastName,alias,active,lastUpdatedOn,device1,...,deviceN`
    if (cells
        case [
          final firstName,
          final lastName,
          final alias,
          final activeAsString,
          final lastUpdatedOnAsString,
          ...final devicesAsStrings,
        ]
        when ImportRidersFileReader.nameIsValid(firstName: firstName, lastName: lastName, alias: alias)) {
      final DateTime lastUpdatedOn;

      try {
        lastUpdatedOn = DateTime.parse(lastUpdatedOnAsString);
      } on FormatException {
        return; // Skip this chunk if it is invalid.
      }

      final bool isActive = ImportRidersFileReader.parseActiveValue(activeAsString);
      final Set<String> devices = {
        for (final device in devicesAsStrings)
          if (Devices.deviceNameRegex.hasMatch(device)) device,
      };

      exportedRiders.add(
        ExportableRider(
          alias: alias,
          devices: devices,
          firstName: firstName,
          isActive: isActive,
          lastName: lastName,
          lastUpdated: lastUpdatedOn,
        ),
      );
    }
  }

  @override
  Future<List<String>> readFile(fs.File file) async {
    final lines = await file.openRead().transform(utf8.decoder).transform(const LineSplitter()).toList();

    if (lines.isEmpty) {
      return lines;
    }

    // Check that the header is present. The header is required for CSV files,
    // otherwise there is no way to determine where the actual data starts.
    if (!headerRegex.hasMatch(lines.first)) {
      throw const FormatException('The header of the CSV file is malformed');
    }

    // Return the lines, without the header.
    return lines.sublist(1);
  }
}
