
import 'dart:convert';
import 'dart:io';

import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/tuple.dart';

class CsvHeaderMissingError extends ArgumentError {
  CsvHeaderMissingError(): super.value("A csv file requires a header line.");
}

/// This class will read the contents of CSV files.
class CsvFileReader {

  /// Read the lines from the given file.
  Future<List<String>> _readLines(File file){
    return file.openRead().transform(utf8.decoder).transform(LineSplitter()).toList();
  }

  /// Read the [Member]s and their [Device]s from the given file.
  /// The [generateId] function is used to generate UUIDs for member objects.
  /// The [headerRegex] is used to strip any possible csv header.
  Future<Tuple<Set<Member>,Set<Device>>> readMembersFromFile(File file, String Function() generateId, String headerRegex) async {
    List<String> lines = await _readLines(file);
    //Return fast when there are no lines.
    if(lines.isEmpty) return Tuple<Set<Member>,Set<Device>>(Set(), Set());

    //These collections will contain the items we need to insert.
    //Because these are Sets, they disallow duplicates.
    final Set<Member> members = Set();
    final Set<Device> devices = Set();
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
      lineReaders.add(_processLine(line, members, devices, generateId));
    }

    await Future.wait(lineReaders);

    return Tuple<Set<Member>,Set<Device>>(members, devices);
  }

  //Process the given line of data and add the member and devices to the given collections.
  //This function is a future, so we can process multiple lines at once.
  Future<void> _processLine(String line, Set<Member> members, Set<Device> devices, String Function() generateId) async {
    final List<String> values = line.split(',');

    //If the line doesn't have enough cells to fill the required fields
    // (first name, last name and alias, in that order), skip it
    if(values.length < 3){
      return null;
    }

    //Invalid data lines are skipped
    if(!Member.personNameAndAliasRegex.hasMatch(values[0]) || !Member.personNameAndAliasRegex.hasMatch(values[1]) || (values[2].isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(values[2]))){
      return null;
    }

    //Create the member and add it to the list
    final Member member = Member(
      generateId(),
      values[0],
      values[1],
      values[2],
    );

    members.add(member);

    //Besides First Name, Last Name, Alias, there are more values
    //These are the device names: Device1, Device2,... , DeviceN
    if(values.length > 3){
      //Check the device names
      final deviceNames = values.sublist(3);

      //Remove the invalid ones but keep the rest
      deviceNames.retainWhere((deviceName) => Device.deviceNameRegex.hasMatch(deviceName));

      //Add the devices to the collection. Since its a Set, duplicates are ignored.
      deviceNames.forEach((String deviceName) => devices.add(Device(name: deviceName, creationDate: DateTime.now(), ownerId: member.uuid, type: DeviceType.UNKNOWN)));
    }
  }
}