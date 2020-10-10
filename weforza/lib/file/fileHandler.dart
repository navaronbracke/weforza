
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

enum FileExtension {
  JSON, CSV
}

class NoFileChosenError extends ArgumentError {
  NoFileChosenError(): super.notNull("file");
}

class InvalidFileFormatError extends ArgumentError {
  InvalidFileFormatError(): super("file format is invalid");
}

extension ToFileTypeExtension on FileExtension {
  String extension(){
    switch(this){
      case FileExtension.JSON: return ".json";
      case FileExtension.CSV: return ".csv";
    }
    return null;
  }
}

///This class provides a contract to work with [File].
abstract class IFileHandler {

  ///Pick an image from the device gallery.
  ///Returns the [File] that was picked or null otherwise.
  Future<File> chooseProfileImageFromGallery();

  ///Load a file from the given [path].
  ///Returns the [File] if it exists, or null otherwise.
  Future<File> loadProfileImageFromDisk(String path);

  ///Choose the file to use as datasource,
  ///from which to import members and their devices.
  Future<File> chooseImportMemberDatasourceFile();

  //Create a file with the given name and extension.
  Future<File> createFile(String fileName, String extension);
}

///This class is an implementation of [IFileHandler].
class FileHandler implements IFileHandler {

  @override
  Future<File> chooseProfileImageFromGallery() async {
    final FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.image);

    if(result == null || result.files == null || result.files.isEmpty) return null;

    return File(result.files.first.path);
  }

  @override
  Future<File> loadProfileImageFromDisk(String path) async {
    if(path == null || path.isEmpty){
      return null;
    }
    else {
      File image = File(path);
      return await image.exists() ? image : null;
    }
  }

  @override
  Future<File> chooseImportMemberDatasourceFile() async {
    final FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: <String>['csv','json']);

    if(result == null || result.files == null || result.files.isEmpty) return Future.error(NoFileChosenError());

    if(!result.files.first.extension.endsWith('csv') || !result.files.first.extension.endsWith('json')){
      return Future.error(InvalidFileFormatError());
    }

    return File(result.files.first.path);
  }

  @override
  Future<File> createFile(String fileName, String extension) async {
    Directory directory;

    if(Platform.isAndroid){
      directory = await getExternalStorageDirectory();
    }else if(Platform.isIOS){
      directory = await getApplicationDocumentsDirectory();
    }else{
      throw Exception("Only Android and IOS are supported");
    }

    if(directory == null){
      throw Exception("Could not create file path");
    }

    final String path = directory.path + Platform.pathSeparator + fileName + extension;

    return File(path);
  }
}