
import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/model/member.dart';

/// This class will read the contents of CSV files.
class CsvFileReader {

  /// Read the lines from the given file.
  Future<List<String>> _readLines(File file){
    return file.openRead().transform(utf8.decoder).transform(LineSplitter()).toList();
  }

  /// Read the [Member]s and their [Device]s from the given file.
  /// The [headerRegex] is used to strip any possible csv header.
  Future<Iterable<ExportableMember>> readMembersFromFile(File file, String headerRegex) async {
    // This list will hold the final output.
    final List<ExportableMember> exports = [];

    List<String> lines = await _readLines(file);

    //Return fast when there are no lines.
    if(lines.isEmpty) return exports;

    // This list contains the line readers that will run in parallel.
    final List<Future<void>> lineReaders = [];

    //Remove all the spaces in the possible and turn into lower case.
    //This way we can do a regex check for the header presence.
    final possibleHeader = lines[0].toLowerCase();

    // Check that the header is required.
    if(!RegExp("^$headerRegex\$").hasMatch(possibleHeader)){
      return Future.error(CsvHeaderMissingError());
    }

    // Remove the header.
    lines = lines.sublist(1);

    //Add a line processor for each line and run them in parallel.
    for(String line in lines){
      lineReaders.add(_processLine(line, exports));
    }

    await Future.wait(lineReaders);

    return exports;
  }

  //Process the given line of data and add the member and devices to the given collection.
  //This function is a future, so we can process multiple lines at once.
  Future<void> _processLine(String line, List<ExportableMember> collection) async {
    final List<String> values = line.split(',');

    //If the line doesn't have enough cells to fill the required fields
    // (first name, last name and alias, in that order), skip it
    if(values.length < 3){
      return;
    }

    //Invalid data lines are skipped
    if(!Member.personNameAndAliasRegex.hasMatch(values[0]) || !Member.personNameAndAliasRegex.hasMatch(values[1]) || (values[2].isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(values[2]))){
      return;
    }

    // This Set will keep the device names.
    // Since its a Set, duplicates are ignored.
    final Set<String> devices = Set();

    //Besides First Name, Last Name, Alias, there are more values
    //These are the device names: Device1, Device2,... , DeviceN
    if(values.length > 3){
      //Filter the invalid device names.
      devices.addAll(values.sublist(3).where((deviceName) => Device.deviceNameRegex.hasMatch(deviceName)));
    }

    collection.add(ExportableMember(
      firstName: values[0],
      lastName: values[1],
      alias: values[2],
      devices: devices
    ));
  }
}