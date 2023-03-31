import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/exceptions/exceptions.dart';

/// This enum defines the supported file extensions for importing and exporting.
enum FileExtension {
  csv(),
  json();

  const FileExtension();

  /// Get the actual file extension for this extension type.
  ///
  /// The returned extension includes a leading dot.
  String get ext {
    switch (this) {
      case FileExtension.json:
        return '.json';
      case FileExtension.csv:
        return '.csv';
    }
  }
}

/// This interface provides methods to work with [File]s.
abstract class FileHandler {
  /// Pick a profile image from the device gallery.
  /// Returns the [File] that was chosen.
  Future<File?> chooseProfileImageFromGallery();

  /// Load a profile image from the given [path].
  /// Returns the [File] if it exists, or null otherwise.
  Future<File?> loadProfileImageFromDisk(String? path);

  /// Choose the file to use as datasource
  /// for importing members and their devices.
  Future<File> chooseImportMemberDatasourceFile();

  /// Create a file with the given [fileName] and [extension].
  Future<File> createFile(String fileName, String extension);
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
  Future<File?> loadProfileImageFromDisk(String? path) async {
    if (path == null || path.isEmpty) {
      return null;
    }

    final image = File(path);

    return await image.exists() ? image : null;
  }

  @override
  Future<File> chooseImportMemberDatasourceFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['csv', 'json'],
    );

    if (result == null || result.files.isEmpty) {
      return Future.error(NoFileChosenError());
    }

    final chosenFile = result.files.first;
    final ext = chosenFile.extension;

    if (ext == null || (!ext.endsWith('csv') && !ext.endsWith('json'))) {
      return Future.error(InvalidFileExtensionError());
    }

    if (chosenFile.path == null) {
      return Future.error(InvalidFileExtensionError());
    }

    return File(chosenFile.path!);
  }

  @override
  Future<File> createFile(String fileName, String extension) async {
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

    return File(directory.path + Platform.pathSeparator + fileName + extension);
  }
}
