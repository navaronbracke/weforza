
import 'dart:convert';
import 'dart:io';

import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/tuple.dart';

/// This class will read the contents of JSON files.
class JsonFileReader {

  /// Read the [Member]s and their [Device]s from the given file.
  /// The [generateId] function is used to generate UUIDs for member objects.
  Future<Tuple<Set<Member>,Set<Device>>> readMembersFromFile(File file, String Function() generateId) async {
    // We don't yet know if each item is a Map<String,dynamic>.
    // This check has to happen on a per item basis during the reader step.
    List<dynamic> jsonItems = await _readJsonItems(file);

    //Return fast when there are no json items.
    if(jsonItems.isEmpty) return Tuple<Set<Member>,Set<Device>>(Set(), Set());

    //These collections will contain the items we need to insert.
    //Because these are Sets, they disallow duplicates.
    final Set<Member> members = Set();
    final Set<Device> devices = Set();
    final List<Future<void>> jsonItemReaders = [];

    //Add an object processor for each object and run them in parallel.
    for(Map<String,dynamic> json in jsonItems){
      jsonItemReaders.add(_processJsonItem(json, members, devices, generateId));
    }

    await Future.wait(jsonItemReaders);

    return Tuple<Set<Member>,Set<Device>>(members, devices);
  }

  Future<List<dynamic>> _readJsonItems(File file) async {
    Map<String, dynamic> json = jsonDecode(await file.readAsString());

    // The required key is not in the map.
    if(json["members"] == null){
      throw InvalidFileFormatError();
    }

    // The value is not a List<dynamic>.
    if(!json["members"] is List<dynamic>){
      throw InvalidFileFormatError();
    }

    // The value exists and its a list.
    // The items are dynamic however.
    // Checking each item's type & data needs to happen in the object readers.
    return json["members"];
  }

  // Process the given json object and add the member and devices to the given collections.
  // This function is a future, so we can process multiple json objects at once.
  Future<void> _processJsonItem(dynamic json, Set<Member> members, Set<Device> devices, String Function() generateId) async {
    // Only process Map<String,dynamic> items.
    if(!json is Map<String, dynamic>){
      return;
    }

    // The item doesn't have the required keys.
    if(json["firstName"] == null || json["lastName"] == null || json["alias"] == null || json["devices"] == null){
      return;
    }

    // The items are not of the required data type.
    if(!json["firstName"] is String || !json["lastName"] is String || !json["alias"] is String || json["devices"] is List<dynamic>){
      return;
    }

    final String firstName = json["firstName"] as String;
    final String lastName = json["lastName"] as String;
    final String alias = json["alias"] as String;
    final List<String> deviceNames = _castListOfDynamicToListOfString(json["devices"] as List<dynamic>);

    // The first name, last name or alias are not suitable for a member.
    if(!Member.personNameAndAliasRegex.hasMatch(firstName) || !Member.personNameAndAliasRegex.hasMatch(lastName) || !Member.personNameAndAliasRegex.hasMatch(alias)){
      return;
    }

    //Create the member and add it to the list
    final Member member = Member(
      generateId(),
      firstName,
      lastName,
      alias,
    );

    members.add(member);

    //Remove the invalid ones but keep the rest
    deviceNames.retainWhere((deviceName) => Device.deviceNameRegex.hasMatch(deviceName));

    //Add the devices to the collection. Since its a Set, duplicates are ignored.
    deviceNames.forEach((String deviceName) => devices.add(Device(name: deviceName, creationDate: DateTime.now(), ownerId: member.uuid, type: DeviceType.UNKNOWN)));
  }

  /// Convert a list of dynamic items to a list of String.
  List<String> _castListOfDynamicToListOfString(List<dynamic> items) {
    return items.where((dynamic item) => item is String)
        .map((dynamic item) => item as String).toList();
  }
}