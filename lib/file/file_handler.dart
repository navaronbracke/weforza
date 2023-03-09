import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/exceptions/exceptions.dart';

/// This interface provides methods to work with [File]s.
abstract class FileHandler {
  /// Get the directory where the application can store publicly accessible files.
  Future<Directory> getPublicDocumentsDirectory();

  /// Choose a directory using a directory picker.
  ///
  /// Returns the chosen directory, or null if none was chosen.
  Future<Directory?> pickDirectory();

  /// Choose the file to use as data source
  /// for importing riders and their devices.
  ///
  /// Returns the chosen file or null if no file was chosen.
  /// Throws an [UnsupportedFileFormatException] if a file with an unsupported file type was chosen.
  Future<File?> pickImportRidersDataSource();

  /// Pick a profile image from the given [source].
  /// Returns the [File] that was chosen.
  Future<File?> pickProfileImage(ImageSource source);
}

/// The default implementation of [FileHandler].
class IoFileHandler implements FileHandler {
  @override
  Future<Directory> getPublicDocumentsDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Only Android and IOS are supported');
    }

    if (directory == null) {
      throw ArgumentError.notNull('directory');
    }

    return directory;
  }

  @override
  Future<Directory?> pickDirectory() async {
    final String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath == null) {
      return null;
    }

    // `getDirectoryPath()` returns `/` if the directory is protected.
    if (Platform.isAndroid && directoryPath == Platform.pathSeparator) {
      throw DirectoryProtectedException();
    }

    return Directory(directoryPath);
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
      throw UnsupportedFileFormatException();
    }

    if (chosenFile.path == null) {
      throw UnsupportedFileFormatException();
    }

    return File(chosenFile.path!);
  }

  @override
  Future<File?> pickProfileImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      maxHeight: 320,
      maxWidth: 320,
      requestFullMetadata: false,
      source: source,
    );

    if (file == null) {
      return null;
    }

    switch (source) {
      case ImageSource.camera:
        // Get a new file handle
        // for a file with the same name in the documents directory.
        final Directory publicDocumentsDirectory = await getPublicDocumentsDirectory();
        final File destinationFile = File(publicDocumentsDirectory.path + Platform.pathSeparator + file.name);

        await file.saveTo(destinationFile.path);

        return destinationFile;
      case ImageSource.gallery:
        return File(file.path);
    }
  }
}
