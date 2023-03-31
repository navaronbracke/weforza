
import 'dart:convert';
import 'dart:io';

import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/importMembersFileReader.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/model/member.dart';

/// This class will read the contents of JSON files.
class JsonFileReader implements ImportMembersFileReader<Map<String, dynamic>> {

  // Process the given data and add it to collection if its valid.
  // This function is a future, so we can process multiple json objects at once.
  @override
  Future<void> processData(Map<String, dynamic> data, List<ExportableMember> collection) async {
    String firstName;
    String lastName;
    String alias;
    bool isActive;
    List<String> deviceNames;

    try{
      firstName = data["firstName"] as String;
      lastName = data["lastName"] as String;
      alias = data["alias"] as String;
      isActive = data["active"] as bool;
      deviceNames = (data["devices"] as List).cast<String>();

      // The first name, last name or alias are not suitable for a member.
      if(!Member.personNameAndAliasRegex.hasMatch(firstName) || !Member.personNameAndAliasRegex.hasMatch(lastName) || alias.isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(alias)){
        return;
      }

      collection.add(ExportableMember(
          firstName: firstName,
          lastName: lastName,
          alias: alias,
          isActiveMember: isActive,
          devices: deviceNames.where((deviceName) => Device.deviceNameRegex.hasMatch(deviceName)).toSet()
      ));
    }catch(e){
      //Skip this item, instead of throwing an error.
    }
  }

  /// Read the individual json objects of the given [file].
  /// Throws a [JsonFormatIncompatibleException] if the file is not valid json.
  /// Returns the lines that were read from the file.
  /// Returns an empty list if the file is empty.
  @override
  Future<List<Map<String, dynamic>>> readFile(File file) async {
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
}