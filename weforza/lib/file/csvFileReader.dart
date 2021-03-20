
import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/importMembersFileReader.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/model/member.dart';

/// This class will read the contents of CSV files.
class CsvFileReader implements ImportMembersFileReader<String> {
  CsvFileReader({
    required this.headerRegex,
  }): assert(headerRegex.isNotEmpty);

  final String headerRegex;

  //Process the given data and add it to the given collection, if it is valid.
  //This function is a future, so we can process multiple lines at once.
  @override
  Future<void> processData(String data, List<ExportableMember> collection) async {
    final List<String> values = data.split(',');

    //If the line doesn't have enough cells to fill the required fields
    // (first name, last name, alias, active) in that order, skip it
    if(values.length < 4){
      return;
    }

    final String firstName = values[0];
    final String lastName = values[1];
    final String alias = values[2];
    final String isActiveAsString = values[3].toLowerCase();

    // Invalid data lines are skipped.
    // Check firstname, lastname & alias by regex.
    if(!Member.personNameAndAliasRegex.hasMatch(firstName) || !Member.personNameAndAliasRegex.hasMatch(lastName) || (alias.isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(alias))){
      return;
    }

    bool isActive;

    if(isActiveAsString == "0" || isActiveAsString == "false"){
      isActive = false;
    }else if(isActiveAsString == "1" || isActiveAsString == "true"){
      isActive = true;
    }else{
      // Invalid cell content, skip.
      return;
    }

    // This Set will keep the device names.
    // Since its a Set, duplicates are ignored.
    final Set<String> devices = Set();

    //Besides First Name, Last Name, Alias, Active there are more values
    //These are the device names: Device1, Device2,... , DeviceN
    if(values.length > 4){
      //Filter the invalid device names.
      devices.addAll(values.sublist(4).where((deviceName) => Device.deviceNameRegex.hasMatch(deviceName)));
    }

    collection.add(ExportableMember(
        firstName: values[0],
        lastName: values[1],
        alias: values[2],
        isActiveMember: isActive,
        devices: devices
    ));
  }

  /// Read the individual lines of the given [file].
  /// Throws a [CsvHeaderMissingError] if the first line doesn't match [headerRegex].
  /// Returns the lines that were read from the file.
  /// Returns an empty list if the file is empty.
  @override
  Future<List<String>> readFile(File file) async {
    final List<String> lines = await file.openRead().transform(utf8.decoder).transform(LineSplitter()).toList();

    if(lines.isEmpty) return lines;

    // FIXME: check that the header that is written by the export function is compatible.
    // Check that the header is present.
    if(!RegExp("^$headerRegex\$").hasMatch(lines.first.toLowerCase())){
      return Future.error(CsvHeaderMissingError());
    }

    // Return the lines, without the header.
    return lines.sublist(1);
  }
}