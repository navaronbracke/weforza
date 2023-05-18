import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weforza/exceptions/exceptions.dart';

/// This interface provides methods to work with [File]s.
abstract class FileHandler {
  /// Get the directories that this file handler can use.
  FileHandlerDirectories get directories;

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
  const IoFileHandler(this.directories);

  @override
  final FileHandlerDirectories directories;

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
        // TODO: register file in Photos app on iOS

        // Save the file into the photos directory.
        final File destinationFile = File(directories.photos.path + Platform.pathSeparator + file.name);

        await file.saveTo(destinationFile.path);

        return destinationFile;
      case ImageSource.gallery:
        return File(file.path);
    }
  }
}

/// This class represents the directories that can be used by a [FileHandler].
class FileHandlerDirectories {
  const FileHandlerDirectories({required this.export, required this.photos});

  /// The directory for export files.
  final Directory export;

  /// The directory for photos.
  final Directory photos;
}
