import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/import_riders_file_reader.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/rider/serializable_rider.dart';

/// This class represents an [ImportRidersFileReader]
/// that handles the CSV format.
class ImportRidersCsvReader implements ImportRidersFileReader<String> {
  const ImportRidersCsvReader._({required this.headerRegex});

  /// The minimum expected amount of columns for a valid data source.
  ///
  /// A CSV file is considered a valid import data source
  /// if and only if it has the following columns:
  /// Column 1: First Name
  /// Column 2: Last Name
  /// Column 3: Alias (This cell can be empty)
  /// Column 4: Active
  /// Column 5: Last Updated On
  static const requiredColumns = 5;

  /// The regular expression that validates the first line in the input file.
  final RegExp headerRegex;

  @override
  Future<void> processChunk(
    String chunk,
    List<SerializableRider> serializedRiders,
  ) async {
    final List<String> cells = chunk.split(',');

    // Skip this line if it does not have enough cells.
    if (cells.length < requiredColumns) {
      return;
    }

    // The cells follow the specific order:
    // `firstName,lastName,alias,active,lastUpdatedOn,device1,...,deviceN`
    final firstName = cells[0];
    final lastName = cells[1];
    final alias = cells[2];

    final regex = Member.personNameAndAliasRegex;

    // If the first name, last name or alias is invalid, skip this chunk.
    if (!regex.hasMatch(firstName) ||
        !regex.hasMatch(lastName) ||
        alias.isNotEmpty && !regex.hasMatch(alias)) {
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
    if (cells.length > requiredColumns) {
      devices.addAll(cells
          .sublist(requiredColumns)
          .where(Device.deviceNameRegex.hasMatch));
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
    final lines = await file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .toList();

    if (lines.isEmpty) {
      return lines;
    }

    // Check that the header is present. The header is required for CSV files,
    // otherwise there is no way to determine where the actual data starts.
    if (!headerRegex.hasMatch(lines.first)) {
      return Future.error(CsvHeaderMissingError());
    }

    // Return the lines, without the header.
    return lines.sublist(1);
  }
}
