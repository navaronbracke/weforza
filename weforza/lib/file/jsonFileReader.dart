
import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/model/member.dart';

/// This class will read the contents of JSON files.
class JsonFileReader {

  Future<List<Map<String, dynamic>>> readObjects(File file) async {
    // The json decode can fail.
    // The cast to a list can fail.
    // The item cast to Map<String, dynamic> can fail.
    try {
      final Map<String, dynamic> json = jsonDecode(await file.readAsString());

      return (json["members"] as List).map((item)=> item as Map<String, dynamic>).toList();
    }catch(e){
      return Future.error(JsonFormatIncompatibleException());
    }
  }

  // Process the given json and add it to collection if its valid.
  // This function is a future, so we can process multiple json objects at once.
  Future<void> processJson(Map<String, dynamic> json, List<ExportableMember> collection){
    String firstName;
    String lastName;
    String alias;
    List<String> deviceNames;

    try{
      firstName = json["firstName"] as String;
      lastName = json["lastName"] as String;
      alias = json["alias"] as String;
      deviceNames = (json["devices"] as List).cast<String>();

      // The first name, last name or alias are not suitable for a member.
      if(!Member.personNameAndAliasRegex.hasMatch(firstName) || !Member.personNameAndAliasRegex.hasMatch(lastName) || alias.isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(alias)){
        return null;
      }

      collection.add(ExportableMember(
          firstName: firstName,
          lastName: lastName,
          alias: alias,
          devices: deviceNames.sublist(3).where((deviceName) => Device.deviceNameRegex.hasMatch(deviceName)).toSet()
      ));

      return null;
    }catch(e){
      return Future.error(JsonFormatIncompatibleException());
    }
  }
}