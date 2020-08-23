import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/tuple.dart';
import 'package:weforza/repository/importMembersRepository.dart';

enum ImportMembersState {
  IDLE, IMPORTING, DONE, PICKING_FILE
}

class ImportMembersBloc extends Bloc {
  ImportMembersBloc({
    @required this.fileHandler,
    @required this.repository,
  }): assert(fileHandler != null && repository != null);

  final IFileHandler fileHandler;
  final ImportMembersRepository repository;

  final Uuid _uuidGenerator = Uuid();

  final StreamController<ImportMembersState> _importStreamController = BehaviorSubject.seeded(ImportMembersState.IDLE);
  Stream<ImportMembersState> get importStream => _importStreamController.stream;

  //Pick a file through a file picker and save the members that were read from the returned file.
  void pickFileAndImportMembers(String headerRegex, ValueNotifier<bool> reloadMembers) async {
    _importStreamController.add(ImportMembersState.PICKING_FILE);

    await fileHandler.chooseImportMemberDatasourceFile().then((file) async {
      _importStreamController.add(ImportMembersState.IMPORTING);
      final Tuple<Set<Member>,Set<Device>> membersAndDevices = await _readMemberDataFromFile(file, headerRegex);
      //Quick exit when there are no members to insert
      //(you can have a dataset full of members without devices however)
      if(membersAndDevices.first.isEmpty) return;

      await _saveMemberData(membersAndDevices.first, membersAndDevices.second);
      reloadMembers.value = true;
      _importStreamController.add(ImportMembersState.DONE);
    }).catchError((error){
      print(error);
      _importStreamController.addError(error);
    });
  }

  Future<Tuple<Set<Member>,Set<Device>>> _readMemberDataFromFile(File file, String headerRegex) async {
    List<String> lines = await fileHandler.readCsvFile(file);
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

    //Remove the header if it exists
    if(RegExp("^$headerRegex\$").hasMatch(possibleHeader)){
      lines = lines.sublist(1);
    }

    //Add a line processor for each line and run them in parallel.
    for(String line in lines){
      lineReaders.add(_processLine(line, members, devices));
    }

    await Future.wait(lineReaders);

    return Tuple<Set<Member>,Set<Device>>(members, devices);
  }

  //Process the given line of data and add the member and devices to the given collections.
  //This function is a future, so we can process multiple lines at once.
  Future<void> _processLine(String line, Set<Member> members, Set<Device> devices) async {
    final List<String> values = line.split(',');

    //If the line doesn't have enough cells to fill the required fields
    // (first name, last name and phone, in that order), skip it
    if(values.length < 3){
      return null;
    }

    //Invalid data lines are skipped
    if(!Member.personNameRegex.hasMatch(values[0]) || !Member.personNameRegex.hasMatch(values[1]) || !Member.phoneNumberRegex.hasMatch(values[2])){
      return null;
    }

    //Create the member and add it to the list
    final Member member = Member(
      _uuidGenerator.v4(),
      values[0],
      values[1],
      values[2],
    );

    members.add(member);

    //Besides First Name, Last Name, Phone, there are more values
    //These are the device names: Device1, Device2,... , DeviceN
    if(values.length > 3){
      //Check the device names
      final deviceNames = values.sublist(3);

      //Remove the invalid ones but keep the rest
      deviceNames.retainWhere((deviceName) => Device.deviceNameRegex.hasMatch(deviceName));

      //Add the devices to the collection. Since its a Set, duplicates are ignored.
      deviceNames.forEach((deviceName) => devices.add(Device(
            name: deviceName,
            creationDate: DateTime.now(),
            ownerId: member.uuid,
            type: DeviceType.UNKNOWN
        )
      ));
    }
  }

  Future<void> _saveMemberData(Set<Member> members, Set<Device> devices)
    => repository.saveMembersWithDevices(members,devices);

  @override
  void dispose(){
    _importStreamController.close();
  }

}