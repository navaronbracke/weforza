import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/file/io_file_system.dart';
import 'package:weforza/riverpod/file/file_storage_delegate_provider.dart';

/// This provider provides the file system.
final fileSystemProvider = Provider<FileSystem>(
  (ref) => IoFileSystem(
    fileStorageDelegate: ref.read(fileStorageDelegateProvider),
  ),
);
