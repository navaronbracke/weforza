import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/file/io_file_system.dart';
import 'package:weforza/riverpod/file/file_storage_delegate_provider.dart';

/// This provider provides the file system.
///
/// This provider should be preloaded with the file system at application startup.
final fileSystemProvider = Provider<FileSystem>(
  (ref) => IoFileSystem(
    fileStorageDelegate: ref.read(fileStorageDelegateProvider),
  ),
);
