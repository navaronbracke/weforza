import 'dart:io' as io show Directory;
import 'package:file/file.dart' as fs;
import 'package:weforza/file/file_system.dart';

/// This class represents a [FileSystem] that uses the real file system.
class IoFileSystem implements FileSystem {
  /// Create a new [IoFileSystem] with the given directories.
  IoFileSystem({
    required io.Directory documentsDirectory,
    required io.Directory imagesDirectory,
    required fs.FileSystem fileSystem,
    required this.hasScopedStorage,
    required io.Directory tempDirectory,
    io.Directory? topLevelDocumentsDirectory,
  })  : documentsDirectory = fileSystem.directory(documentsDirectory),
        imagesDirectory = fileSystem.directory(imagesDirectory),
        tempDirectory = fileSystem.directory(tempDirectory),
        topLevelDocumentsDirectory = hasScopedStorage || topLevelDocumentsDirectory == null
            ? null
            : fileSystem.directory(topLevelDocumentsDirectory),
        _fileSystem = fileSystem;

  @override
  final fs.Directory documentsDirectory;

  @override
  final fs.Directory imagesDirectory;

  @override
  final fs.Directory? topLevelDocumentsDirectory;

  /// The underlying file system.
  final fs.FileSystem _fileSystem;

  @override
  final bool hasScopedStorage;

  @override
  final fs.Directory tempDirectory;

  @override
  fs.File file(String path) => _fileSystem.file(path);
}
