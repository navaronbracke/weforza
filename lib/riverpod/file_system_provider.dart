import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_system.dart';

/// This provider provides the file system.
///
/// This provider should be preloaded with the file system at application startup.
final fileSystemProvider = Provider<FileSystem>(
  (_) => throw UnsupportedError('The file system should be preloaded at startup.'),
);

/// This provider provides the default [Directory] for export files.
@Deprecated('Use the file system instead')
final exportDataDefaultDirectoryProvider = Provider<Directory?>((_) => null);