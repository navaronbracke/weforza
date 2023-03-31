import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/exceptions/exceptions.dart';

/// This interface provides methods to work with [File]s.
abstract class FileHandler {
  /// Pick a profile image from the device gallery.
  /// Returns the [File] that was chosen.
  Future<File?> chooseProfileImageFromGallery();

  /// Get a [File] with the given [fileName].
  ///
  /// Returns a reference to the [File].
  /// This method does not create the underlying file.
  Future<File> getFile(String fileName);

  /// Choose the file to use as data source
  /// for importing riders and their devices.
  ///
  /// Returns the chosen file or null if no file was chosen.
  /// Throws an [UnsupportedFileFormatError] if a file with an unsupported file type was chosen.
  Future<File?> pickImportRidersDataSource();
}

/// The default implementation of [FileHandler].
class IoFileHandler implements FileHandler {
  @override
  Future<File?> chooseProfileImageFromGallery() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final path = result.files.first.path;

    return path == null ? null : File(path);
  }

  @override
  Future<File> getFile(String fileName) async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Only Android and IOS are supported');
    }

    if (directory == null) {
      return Future.error(ArgumentError.notNull('directory'));
    }

    return File(directory.path + Platform.pathSeparator + fileName);
  }

  @override
  Future<File?> pickImportRidersDataSource() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['csv', 'json'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final chosenFile = result.files.first;
    final ext = chosenFile.extension;

    if (ext == null || (!ext.endsWith('csv') && !ext.endsWith('json'))) {
      return Future.error(UnsupportedFileFormatError());
    }

    if (chosenFile.path == null) {
      return Future.error(UnsupportedFileFormatError());
    }

    return File(chosenFile.path!);
  }
}
