import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';

enum ImportMembersState {
  IDLE, IMPORTING, DONE, PICKING_FILE
}

class ImportMembersBloc extends Bloc {
  ImportMembersBloc({@required this.fileHandler}): assert(fileHandler != null);

  IFileHandler fileHandler;

  final StreamController<ImportMembersState> _importStreamController = BehaviorSubject.seeded(ImportMembersState.IDLE);
  Stream<ImportMembersState> get importStream => _importStreamController.stream;

  //Pick a file through a file picker and save the members that were read from the returned file.
  void pickFileAndImportMembers(String headerRegex, ValueNotifier<bool> reloadMembers) async {
    _importStreamController.add(ImportMembersState.PICKING_FILE);

    await fileHandler.chooseImportMemberDatasourceFile().then((file) async {
      _importStreamController.add(ImportMembersState.IMPORTING);
      final List<Map<String,dynamic>> data = await _readMemberDataFromFile(file, headerRegex);

      await _saveMemberData(data);
      reloadMembers.value = true;
      _importStreamController.add(ImportMembersState.DONE);
    }).catchError((error){
      _importStreamController.addError(error);
    });
  }

  Future<List<Map<String, dynamic>>> _readMemberDataFromFile(File file, String headerRegex) async {
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

  Future<void> _saveMemberData(List<Map<String,dynamic>> data){
    //TODO save the list of maps to the database
    //TODO for each member
    //check if exists
    //if it does -> skip
    //else add to collection
    //save members -> after saving map the devices to pairs (member uuid / device name)
    //find all the device names

    //for each device/uuid
  }

  @override
  void dispose(){
    _importStreamController.close();
  }

}