import 'package:file/file.dart' as fs;

/// This interface defines the application's file system.
abstract interface class FileSystem {
  /// Get the directory where the application can store documents.
  ///
  /// Files in this directory are removed when the application is uninstalled.
  fs.Directory get documentsDirectory;

  /// Whether the file system uses scoped storage.
  ///
  /// If this is true, not all provided directories might be available to the application.
  bool get hasScopedStorage;

  /// Get the directory where the application can create temporary files.
  /// This directory is always available.
  fs.Directory get tempDirectory;

  /// Get the directory where the application can store documents,
  /// that are not removed when the application is uninstalled.
  ///
  /// Returns null if no such directory is available.
  fs.Directory? get topLevelDocumentsDirectory;

  /// Get a reference to a [fs.File] at the given [path].
  fs.File file(String path);

  /// Get a reference to a [fs.File] from the given [uri].
  ///
  /// Throws an [ArgumentError] if the given [uri] is not a `file://` Uri.
  fs.File fileFromUri(Uri uri);
}
