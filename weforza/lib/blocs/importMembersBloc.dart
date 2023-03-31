import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';

class ImportMembersBloc extends Bloc {
  ImportMembersBloc({@required this.fileHandler}): assert(fileHandler != null);

  IFileHandler fileHandler;

  File _importFile;

  bool get fileChosen => _importFile != null;

  //Pick a file through a file picker and save the members that were read from the returned file.
  Future<void> pickFileAndImportMembers(String headerRegex) async {
    return fileHandler.chooseImportMemberDatasourceFile(<String>['csv']).then((file) async {
      if(file == null){
        return Future.error("No file chosen");
      }else{
        final List<Map<String,String>> data = await _readMemberDataFromFile(file, headerRegex);

        //TODO save the list of maps to the database
      }
    });
  }

  //TODO mention that the csv needs a header in the UI (we could use a dialog for this, users could tap it)
  Future<List<Map<String, String>>> _readMemberDataFromFile(File file, String headerRegex) async {
    List<String> lines = await file.readAsLines();

    //Remove all the spaces and turn into lower case
    //The first line might be a header
    final possibleHeader = lines[0].replaceAll(" ", "").toLowerCase();

    //Remove the header if it exists
    if(RegExp("^$headerRegex\$").hasMatch(possibleHeader)){
      lines = lines.sublist(1);
    }

    final memberData = <Map<String,dynamic>>[];

    for (String data in lines){
      final List<String> values = data.split(',');
      if(values.length < 3){//First Name, Last Name, Phone
        continue;
      }
      if(!Member.personNameRegex.hasMatch(values[0]) || !Member.personNameRegex.hasMatch(values[1]) || !Member.phoneNumberRegex.hasMatch(values[2])){
        continue;
      }
      //Besides First Name, Last Name, Phone, there are more values
      //These are the device names: Device1, Device2,... , DeviceN
      if(values.length > 3){
        //Check the device names
        final deviceNames = values.sublist(4);
        if(deviceNames.map((deviceName) => !Device.deviceNameRegex.hasMatch(deviceName)).contains(true)){
          continue;
        }
      }
      memberData.add({
        "firstName": values[0],
        "lastName": values[1],
        "phone": values[2],
        "devices": values.length > 3 ? values.sublist(4) : []
      });
    }

    return memberData;
  }

  @override
  void dispose(){}

}