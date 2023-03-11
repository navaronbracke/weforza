import 'dart:convert';
import 'dart:io';

import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/model/device/device.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/serializable_rider.dart';

/// This class represents an [ImportRidersFileReader]
/// that handles the CSV format.
class ImportRidersCsvReader implements ImportRidersFileReader<String> {
  /// The default constructor.
  ///
  /// The cell [delimiter] defaults to a comma.
  factory ImportRidersCsvReader({String delimiter = ','}) {
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

    return ImportRidersCsvReader._(
      headerRegex: RegExp(regexBuilder.toString(), unicode: true),
    );
  }

  /// The private constructor.
  const ImportRidersCsvReader._({required this.headerRegex});

  /// The minimum expected amount of columns for a valid line of data.
  ///
  /// A line is only valid if it contains the following columns:
  /// if and only if it has the following columns:
  /// Column 1: First Name
  /// Column 2: Last Name
  /// Column 3: Alias (This cell can be empty)
  /// Column 4: Active
  /// Column 5: Last Updated On
  static const requiredDataColumns = 5;

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
  Future<void> processChunk(
    String chunk,
    List<SerializableRider> serializedRiders,
  ) async {
    final List<String> cells = chunk.split(',');

    // Skip this line if it does not have enough cells.
    if (cells.length < requiredDataColumns) {
      return;
    }

    // The cells follow the specific order:
    // `firstName,lastName,alias,active,lastUpdatedOn,device1,...,deviceN`
    final firstName = cells[0];
    final lastName = cells[1];
    final alias = cells[2];

    final regex = Rider.personNameAndAliasRegex;

    // If the first name, last name or alias is invalid, skip this chunk.
    if (!regex.hasMatch(firstName) || !regex.hasMatch(lastName) || alias.isNotEmpty && !regex.hasMatch(alias)) {
      return;
    }

    bool active;

    switch (cells[3].toLowerCase()) {
      case '0':
      case 'false':
        active = false;
        break;
      case '1':
      case 'true':
        active = true;
        break;
      default:
        return; // Skip this chunk if it is invalid.
    }

    DateTime lastUpdatedOn;

    try {
      lastUpdatedOn = DateTime.parse(cells[4]);
    } on FormatException {
      return; // Skip this chunk if it is invalid.
    }

    final Set<String> devices = {};

    // Any remaining cells after the required cells are parsed as device names.
    // Any invalid device names are skipped.
    if (cells.length > requiredDataColumns) {
      devices.addAll(cells.sublist(requiredDataColumns).where(Device.deviceNameRegex.hasMatch));
    }

    serializedRiders.add(
      SerializableRider(
        active: active,
        alias: alias,
        devices: devices,
        firstName: firstName,
        lastName: lastName,
        lastUpdated: lastUpdatedOn,
      ),
    );
  }

  @override
  Future<List<String>> readFile(File file) async {
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
