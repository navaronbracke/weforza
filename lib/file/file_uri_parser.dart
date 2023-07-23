import 'dart:io' show Platform;

import 'package:file/file.dart' as fs;
import 'package:weforza/file/file_system.dart';

/// This class parses a path to a file into a valid [Uri].
final class FileUriParser {
  const FileUriParser(this.fileSystem);

  /// The file system that determines how a file [Uri] should be interpreted.
  final FileSystem fileSystem;

  /// Parse the given [path] into a valid [Uri].
  ///
  /// Returns the parsed [Uri] or null if the path does not point to a valid [Uri].
  Uri? parse(String? path) {
    if (path == null) {
      return null;
    }

    // The path could be a valid `content` or `file` Uri.
    // It could also be an actual path on disk.
    final Uri? uri = Uri.tryParse(path);

    // When Scoped Storage is in use on Android, only `content://` Uris are valid.
    if (Platform.isAndroid && fileSystem.hasScopedStorage) {
      if (uri == null || !uri.isScheme('content')) {
        return null;
      }

      return uri;
    }

    // The path does not point to a valid uri, try using it as a file path.
    if (uri == null) {
      final fs.File file = fileSystem.file(path);

      return file.existsSync() ? file.uri : null;
    }

    if (uri.isScheme('file')) {
      return uri;
    }

    return null;
  }
}
