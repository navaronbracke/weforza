import 'package:file/file.dart' as fs;

/// This interface defines the application's file system.
abstract interface class FileSystem {
  /// Whether the file system uses scoped storage.
  ///
  /// If this is true, not all provided directories might be available to the application.
  bool get hasScopedStorage;

  /// Get the directory where the application can create temporary files.
  /// This directory is always available.
  fs.Directory get tempDirectory;

  /// Get the directory where the application can store document files.
  ///
  /// If this directory is not available, for instance if it is limited by [hasScopedStorage],
  /// then this is null.
  ///
  /// If [applicationDirectory] is true, the returned directory will be specific to the application,
  /// rather than top-level shared storage.
  fs.Directory? documentsDirectory({required bool applicationDirectory});

  /// Get a reference to a [fs.File] at the given [path].
  fs.File file(String path);

  /// Get the directory where the application can store images.
  ///
  /// If this directory is not available, for instance if it is limited by [hasScopedStorage],
  /// then this is null.
  ///
  /// If [applicationDirectory] is true, the returned directory will be specific to the application,
  /// rather than top-level shared storage.
  fs.Directory? imagesDirectory({required bool applicationDirectory});
}
