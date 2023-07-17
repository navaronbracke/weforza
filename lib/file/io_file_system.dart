import 'package:file/file.dart' as fs;
import 'package:weforza/file/file_system.dart';

/// This class represents a [FileSystem] that uses the real file system.
class IoFileSystem implements FileSystem {
  /// Create a new [IoFileSystem] with the given directories.
  IoFileSystem({
    required this.documentsDirectory,
    required this.imagesDirectory,
    required fs.FileSystem fileSystem,
    required this.hasScopedStorage,
    required this.tempDirectory,
    fs.Directory? topLevelDocumentsDirectory,
    fs.Directory? topLevelImagesDirectory,
  })  : topLevelDocumentsDirectory = hasScopedStorage ? null : topLevelDocumentsDirectory,
        topLevelImagesDirectory = hasScopedStorage ? null : topLevelImagesDirectory,
        _fileSystem = fileSystem;

  @override
  final fs.Directory documentsDirectory;

  @override
  final fs.Directory imagesDirectory;

  @override
  final fs.Directory? topLevelDocumentsDirectory;

  @override
  final fs.Directory? topLevelImagesDirectory;

  /// The underlying file system.
  final fs.FileSystem _fileSystem;

  @override
  final bool hasScopedStorage;

  @override
  final fs.Directory tempDirectory;

  @override
  fs.File file(String path) => _fileSystem.file(path);
}
