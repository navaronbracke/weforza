
import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/tuple.dart';

/// This class will read the contents of JSON files.
class JsonFileReader {

  /// Read the [Member]s and their [Device]s from the given file.
  /// The [generateId] function is used to generate UUIDs for member objects.
  Future<Tuple<Set<Member>,Set<Device>>> readMembersFromFile(File file, String Function() generateId) async {
    List<Map<String,dynamic>> jsonItems = await _readJsonItems(file);

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

  Future<List<Map<String, dynamic>>> _readJsonItems(File file) async {
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());

    try {
      // The cast to a list can fail.
      // The item cast to Map<String, dynamic> can also fail.
      return (json["members"] as List).map((item)=> item as Map<String, dynamic>).toList();
    }catch(e){
      return Future.error(JsonFormatIncompatibleException());
    }
  }

  // Process the given json object and add the member and devices to the given collections.
  // This function is a future, so we can process multiple json objects at once.
  Future<void> _processJsonItem(Map<String,dynamic> json, Set<Member> members, Set<Device> devices, String Function() generateId) async {
    String firstName;
    String lastName;
    String alias;
    List<String> deviceNames;

    try{
      firstName = json["firstName"] as String;
      lastName = json["lastName"] as String;
      alias = json["alias"] as String;
      deviceNames = (json["devices"] as List).cast<String>();
    }catch(e){
      return Future.error(JsonFormatIncompatibleException());
    }

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
    deviceNames.retainWhere((deviceName) => deviceName != null && Device.deviceNameRegex.hasMatch(deviceName));

    //Add the devices to the collection. Since its a Set, duplicates are ignored.
    deviceNames.forEach((String deviceName) => devices.add(Device(name: deviceName, creationDate: DateTime.now(), ownerId: member.uuid, type: DeviceType.UNKNOWN)));
  }
}