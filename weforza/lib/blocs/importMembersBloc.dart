import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/csvFileReader.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/file/importMembersFileReader.dart';
import 'package:weforza/file/jsonFileReader.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/repository/importMembersRepository.dart';

enum ImportMembersState {
  IDLE, IMPORTING, DONE, PICKING_FILE
}

class ImportMembersBloc extends Bloc {
  ImportMembersBloc({
    required this.fileHandler,
    required this.repository,
  });

  final IFileHandler fileHandler;
  final ImportMembersRepository repository;

  final Uuid _uuidGenerator = Uuid();

  final StreamController<ImportMembersState> _importStreamController = BehaviorSubject.seeded(ImportMembersState.IDLE);
  Stream<ImportMembersState> get importStream => _importStreamController.stream;

  //Pick a file through a file picker and save the members that were read from the returned file.
  void pickFileAndImportMembers(
      String headerRegex,
      ValueNotifier<bool> reloadMembers,
      ValueNotifier<bool> reloadDevices) async
  {
    _importStreamController.add(ImportMembersState.PICKING_FILE);

    await fileHandler.chooseImportMemberDatasourceFile().then((file) async {
      _importStreamController.add(ImportMembersState.IMPORTING);
      final Iterable<ExportableMember> members = await _readMemberDataFromFile(file, headerRegex);
      //Quick exit when there are no members to insert
      if(members.isEmpty) {
        _importStreamController.add(ImportMembersState.DONE);
        return;
      }

      await repository.saveMembersWithDevices(members, () => _uuidGenerator.v4());
      reloadMembers.value = true;
      reloadDevices.value = true;
      _importStreamController.add(ImportMembersState.DONE);
    }).catchError((e){
      _importStreamController.addError(e);
    });
  }

  Future<Iterable<ExportableMember>> _readMemberDataFromFile(File file, String csvHeaderRegex) async {
    if(file.path.endsWith(FileExtension.CSV.extension())){
      return await _readFile<String>(file, CsvFileReader(headerRegex: csvHeaderRegex));
    }else if(file.path.endsWith(FileExtension.JSON.extension())){
      return await _readFile<Map<String, dynamic>>(file, JsonFileReader());
    }else{
      return Future.error(InvalidFileExtensionError());
    }
  }

  Future<List<ExportableMember>> _readFile<T>(File file, ImportMembersFileReader<T> fileReader) async {
    // This list will hold the final output.
    final List<ExportableMember> exports = [];

    // This list contains the object readers that will run in parallel.
    final List<Future<void>> objectReaders = [];

    final List<T> objects = await fileReader.readFile(file);

    // Return fast when there are no objects.
    if(objects.isEmpty) return exports;

    // Add a line processor for each object and run them in parallel.
    for(T object in objects){
      objectReaders.add(fileReader.processData(object, exports));
    }

    // Wait for the processors to finish.
    await Future.wait(objectReaders);

    return exports;
  }

  @override
  void dispose(){
    _importStreamController.close();
  }

}