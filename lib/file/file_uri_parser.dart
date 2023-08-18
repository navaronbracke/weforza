import 'package:file/file.dart' as fs;
import 'package:os_detect/os_detect.dart' as platform;
import 'package:weforza/file/file_system.dart';

/// This class parses a path to a file into a valid [Uri].
final class FileUriParser {
  const FileUriParser(this.fileSystem);

  /// The file system that determines how a file [Uri] should be interpreted.
  final FileSystem fileSystem;

  /// Parse the given [path] into a valid [Uri].
  ///
  /// The [path] can be a content Uri, a file Uri or an absolute path to a file.
  ///
  /// Returns the parsed [Uri] or null if the path does not point to a valid [Uri].
  Uri? parse(String? path) {
    if (path == null) {
      return null;
    }

    // In case the path is an absolute file path, the Uri might have a scheme.
    // Regardless, aboslute paths are valid Uris.
    final Uri? uri = Uri.tryParse(path);

    if (uri == null) {
      return null;
    }

    // Only Android supports `content://` Uris.
    if (platform.isAndroid && uri.isScheme('content')) {
      return uri;
    }

    // File Uri's are always valid.
    if (uri.isScheme('file')) {
      return uri;
    }

    // If it's neither a content Uri or a file Uri,
    // it might be an absolute file path.
    final fs.File file = fileSystem.file(path);

    return file.existsSync() ? file.uri : null;
  }
}
