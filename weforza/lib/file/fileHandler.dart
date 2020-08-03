
import 'dart:io';

import 'package:file_picker/file_picker.dart';

///This class provides a contract to work with [File].
abstract class IFileHandler {

  ///Pick an image from the device gallery.
  ///Returns the [File] that was picked or null otherwise.
  Future<File> chooseProfileImageFromGallery();

  ///Load a file from the given [path].
  ///Returns the [File] if it exists, or null otherwise.
  Future<File> loadProfileImageFromDisk(String path);

  Future<File> chooseImportMemberDatasourceFile(List<String> allowedFileExtensions);
}

///This class is an implementation of [IFileHandler].
class FileHandler implements IFileHandler {

  @override
  Future<File> chooseProfileImageFromGallery() => FilePicker.getFile(type: FileType.image);

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
  Future<File> chooseImportMemberDatasourceFile(List<String> allowedFileExtensions)
    => FilePicker.getFile(type: FileType.custom, allowedExtensions: allowedFileExtensions);

}