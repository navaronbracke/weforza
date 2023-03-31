import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/csvFileReader.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/file/jsonFileReader.dart';
import 'package:weforza/model/exportableMember.dart';
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
      final Iterable<ExportableMember> members = await _readMemberDataFromFile(file, headerRegex);
      //Quick exit when there are no members to insert
      //(you can have a dataset full of members without devices however)
      if(members.isEmpty) return;

      await repository.saveMembersWithDevices(members, () => _uuidGenerator.v4());
      reloadMembers.value = true;
      _importStreamController.add(ImportMembersState.DONE);
    }).catchError(_importStreamController.addError);
  }

  Future<Iterable<ExportableMember>> _readMemberDataFromFile(File file, String csvHeaderRegex) async {
    if(file.path.endsWith(FileExtension.CSV.extension())){
      final fileReader = CsvFileReader();

      return fileReader.readMembersFromFile(file, csvHeaderRegex);
    }else if(file.path.endsWith(FileExtension.JSON.extension())){
      final fileReader = JsonFileReader();

      return fileReader.readMembersFromFile(file);
    }

    return Future.error(InvalidFileExtensionError());
  }

  @override
  void dispose(){
    _importStreamController.close();
  }

}