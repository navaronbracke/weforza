import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/csvFileReader.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/file/jsonFileReader.dart';
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

  Future<Tuple<Set<Member>,Set<Device>>> _readMemberDataFromFile(File file, String csvHeaderRegex) async {
    if(file.path.endsWith(FileExtension.CSV.extension())){
      final fileReader = CsvFileReader();

      return fileReader.readMembersFromFile(file, () => _uuidGenerator.v4(), csvHeaderRegex);
    }else if(file.path.endsWith(FileExtension.JSON.extension())){
      final fileReader = JsonFileReader();

      return fileReader.readMembersFromFile(file, () => _uuidGenerator.v4());
    }

    return Tuple<Set<Member>,Set<Device>>(Set(), Set());
  }

  Future<void> _saveMemberData(Set<Member> members, Set<Device> devices)
    => repository.saveMembersWithDevices(members,devices);

  @override
  void dispose(){
    _importStreamController.close();
  }

}