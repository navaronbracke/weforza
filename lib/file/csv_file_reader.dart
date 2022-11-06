import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/import_members_file_reader.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/member.dart';

/// This class implements a line reader for CSV files.
class CsvFileReader implements ImportMembersFileReader<String> {
  CsvFileReader({required this.headerRegex});

  /// The regex that validates the structure of the CSV header line.
  final RegExp headerRegex;

  /// The minimum required cell count for data lines in the CSV file.
  final int minimumCellCount = 5;

  @override
  Future<void> processData(
    String data,
    List<ExportableMember> collection,
  ) async {
    final List<String> values = data.split(',');

    // If the line doesn't have enough cells
    // to fill the required fields, skip it.
    if (values.length < minimumCellCount) {
      return;
    }

    final String firstName = values[0];
    final String lastName = values[1];
    final String alias = values[2];
    final String isActiveAsString = values[3].toLowerCase();
    final String lastUpdateString = values[4];

    // Invalid data lines are skipped.
    // Check first name, last name & alias by regex.
    if (!Member.personNameAndAliasRegex.hasMatch(firstName) ||
        !Member.personNameAndAliasRegex.hasMatch(lastName) ||
        (alias.isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(alias))) {
      return;
    }

    bool isActive;

    if (isActiveAsString == '0') {
      isActive = false;
    } else if (isActiveAsString == '1') {
      isActive = true;
    } else {
      // Invalid cell content, skip.
      return;
    }

    DateTime lastUpdated;

    try {
      lastUpdated = DateTime.parse(lastUpdateString);
    } on FormatException {
      // Invalid timestamp.
      return;
    }

    // This Set will keep the device names.
    // Since its a Set, duplicates are ignored.
    final Set<String> devices = {};

    // Besides First Name, Last Name, Alias, Active, Last Update
    // there are more values.
    // These are the device names: Device1, Device2,... , DeviceN
    if (values.length > minimumCellCount) {
      devices.addAll(values
          .sublist(minimumCellCount)
          .where(Device.deviceNameRegex.hasMatch));
    }

    collection.add(
      ExportableMember(
        firstName: firstName,
        lastName: lastName,
        alias: alias,
        active: isActive,
        devices: devices,
        lastUpdated: lastUpdated,
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

    // Check that the header is present.
    if (!headerRegex.hasMatch(lines.first)) {
      return Future.error(CsvHeaderMissingError());
    }

    // Return the lines, without the header.
    return lines.sublist(1);
  }
}
