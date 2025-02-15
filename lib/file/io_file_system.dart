import 'dart:io' as io show Directory, Platform;

import 'package:file/file.dart' as fs;
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/native_service/file_storage_delegate.dart';

/// This class represents a [FileSystem] that uses the real file system.
class IoFileSystem implements FileSystem {
  /// Create a new [IoFileSystem].
  factory IoFileSystem({required FileStorageDelegate fileStorageDelegate}) {
    final IoFileSystem delegate = IoFileSystem._(const LocalFileSystem());

    delegate._initialize(fileStorageDelegate);

    return delegate;
  }

  /// The private constructor.
  IoFileSystem._(this._fileSystem);

  /// The underlying file system.
  final fs.FileSystem _fileSystem;

  @override
  late final fs.Directory documentsDirectory;

  @override
  late final fs.Directory? topLevelDocumentsDirectory;

  @override
  late final bool hasScopedStorage;

  @override
  late final fs.Directory tempDirectory;

  @override
  fs.File file(String path) => _fileSystem.file(path);

  @override
  fs.File fileFromUri(Uri uri) {
    if (!uri.isScheme('file')) {
      throw ArgumentError.value(uri, 'uri', 'The given Uri is not a "file://" Uri.');
    }

    return _fileSystem.file(uri);
  }

  /// Set up the file system by loading the necessary directory information.
  void _initialize(FileStorageDelegate fileStorageDelegate) async {
    documentsDirectory = await getApplicationDocumentsDirectory().then(_fileSystem.directory);
    tempDirectory = await getTemporaryDirectory().then(_fileSystem.directory);
    hasScopedStorage = await fileStorageDelegate.hasScopedStorage();

    List<io.Directory>? topLevelDocumentDirectories;

    // Android only has top level directories when Scoped Storage is not being used,
    // while iOS does not have accessible top level directories.
    if (io.Platform.isAndroid && !hasScopedStorage) {
      topLevelDocumentDirectories = await getExternalStorageDirectories(type: StorageDirectory.documents);
    }

    topLevelDocumentsDirectory =
        topLevelDocumentDirectories != null && topLevelDocumentDirectories.isNotEmpty
            ? _fileSystem.directory(topLevelDocumentDirectories.first)
            : null;
  }
}
