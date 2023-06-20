import 'dart:io' show Platform;

import 'package:file/file.dart' as fs;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_system.dart';

/// This class represents a [FileSystem] that uses the real file system.
class IoFileSystem implements FileSystem {
  /// Create a new [IoFileSystem] with the given directories.
  IoFileSystem({
    required fs.Directory applicationDocumentsDirectory,
    required fs.Directory applicationImagesDirectory,
    required fs.FileSystem fileSystem,
    required this.hasScopedStorage,
    required this.tempDirectory,
    fs.Directory? documentsDirectory,
    fs.Directory? imagesDirectory,
  })  : _applicationDocumentsDirectory = applicationDocumentsDirectory,
        _applicationImagesDirectory = applicationImagesDirectory,
        _documentsDirectory = documentsDirectory,
        _fileSystem = fileSystem,
        _imagesDirectory = imagesDirectory;

  /// The directory for application private files.
  final fs.Directory _applicationDocumentsDirectory;

  /// The directory for application private images.
  final fs.Directory _applicationImagesDirectory;

  /// The directory for documents that are not private to the application.
  final fs.Directory? _documentsDirectory;

  /// The directory for images that are not private to the application.
  final fs.Directory? _imagesDirectory;

  /// The underlying file system.
  final fs.FileSystem _fileSystem;

  @override
  final bool hasScopedStorage;

  @override
  final fs.Directory tempDirectory;

  /// Create a new [IoFileSystem] from the directories provided by the current platform.
  static Future<IoFileSystem> fromPlatform({
    required fs.FileSystem fileSystem,
    required bool hasAndroidScopedStorage,
  }) async {
    final tempDirectory = await getTemporaryDirectory();
    final fs.Directory applicationDocumentsDirectory = await getApplicationDocumentsDirectory().then(
      (dir) => fileSystem.directory(dir.path),
    );

    if (Platform.isAndroid) {
      // Don't fetch the external storage directories when they are not available.
      if (hasAndroidScopedStorage) {
        return IoFileSystem(
          applicationDocumentsDirectory: applicationDocumentsDirectory,
          applicationImagesDirectory: applicationDocumentsDirectory,
          fileSystem: fileSystem,
          hasScopedStorage: true,
          tempDirectory: fileSystem.directory(tempDirectory.path),
        );
      }

      final documentsDirs = await getExternalStorageDirectories(type: StorageDirectory.documents) ?? [];
      final imagesDirs = await getExternalStorageDirectories(type: StorageDirectory.pictures) ?? [];

      return IoFileSystem(
        applicationDocumentsDirectory: applicationDocumentsDirectory,
        applicationImagesDirectory: applicationDocumentsDirectory,
        documentsDirectory: documentsDirs.isEmpty ? null : fileSystem.directory(documentsDirs.first.path),
        imagesDirectory: imagesDirs.isEmpty ? null : fileSystem.directory(imagesDirs.first.path),
        fileSystem: fileSystem,
        hasScopedStorage: hasAndroidScopedStorage,
        tempDirectory: fileSystem.directory(tempDirectory.path),
      );
    }

    if (Platform.isIOS) {
      return IoFileSystem(
        applicationDocumentsDirectory: applicationDocumentsDirectory,
        applicationImagesDirectory: applicationDocumentsDirectory,
        fileSystem: fileSystem,
        hasScopedStorage: false,
        tempDirectory: fileSystem.directory(tempDirectory.path),
      );
    }

    throw UnsupportedError('Only Android and iOS are currently supported.');
  }

  @override
  fs.Directory? documentsDirectory({required bool applicationDirectory}) {
    if (Platform.isAndroid) {
      // The documents directory is protected with scoped storage.
      if (hasScopedStorage) {
        return null;
      }

      if (applicationDirectory) {
        return _fileSystem.directory(_applicationDocumentsDirectory);
      }

      final fs.Directory? dir = _documentsDirectory;

      return dir == null ? null : _fileSystem.directory(dir.path);
    }

    if (Platform.isIOS) {
      return _fileSystem.directory(_applicationDocumentsDirectory);
    }

    return null;
  }

  @override
  fs.File file(String path) => _fileSystem.file(path);

  @override
  fs.Directory? imagesDirectory({required bool applicationDirectory}) {
    if (Platform.isAndroid) {
      // The pictures directory is protected with scoped storage.
      if (hasScopedStorage) {
        return null;
      }

      if (applicationDirectory) {
        return _fileSystem.directory(_applicationImagesDirectory);
      }

      final fs.Directory? dir = _imagesDirectory;

      return dir == null ? null : _fileSystem.directory(dir.path);
    }

    // iOS does not have a pictures directory.
    if (Platform.isIOS) {
      return _fileSystem.directory(_applicationDocumentsDirectory);
    }

    return null;
  }

  @override
  Future<fs.File?> pickImportRidersDataSource() async {
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

    final filePath = chosenFile.path;

    if (filePath == null) {
      throw UnsupportedFileFormatException();
    }

    return file(filePath);
  }

  @override
  Future<fs.File?> pickProfileImage(ImageSource source) async {
    // TODO: refactor this flow
    // - if scoped storage on Android, register the photo (the registration should return a readable path)
    // - if not scoped storage on Android
    //   - request write external storage permission first
    //   - then save the image to the top-level pictures dir
    //   - then register the photo
    // - on iOS
    //   - request permission for the photo gallery (add only)
    //   - save the image to the application documents dir
    //   - register the photo

    final profileImage = await ImagePicker().pickImage(
      maxHeight: 320,
      maxWidth: 320,
      requestFullMetadata: false,
      source: source,
    );

    if (profileImage == null) {
      return null;
    }

    switch (source) {
      case ImageSource.camera:
        final fs.Directory? directory = imagesDirectory(applicationDirectory: false);

        if (directory == null) {
          throw ArgumentError.notNull('directory');
        }

        final fs.File destinationFile = file(join(directory.path, profileImage.name));

        await profileImage.saveTo(destinationFile.path);

        return destinationFile;
      case ImageSource.gallery:
        return file(profileImage.path);
    }
  }
}
