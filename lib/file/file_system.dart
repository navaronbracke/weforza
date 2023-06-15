import 'package:file/file.dart' as fs;
import 'package:image_picker/image_picker.dart';

/// This interface defines the application's file system.
abstract interface class FileSystem {
  /// Whether the file system uses scoped storage.
  ///
  /// If this is true, not all provided directories are available to the application.
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

  /// Choose a directory using a directory picker.
  ///
  /// Returns the chosen directory, or null if none was chosen.
  @Deprecated('Use the file system getter instead')
  Future<fs.Directory?> pickDirectory();

  /// Choose the file to use as data source
  /// for importing riders and their devices.
  ///
  /// Returns the chosen file or null if no file was chosen.
  /// Throws an [UnsupportedFileFormatException] if a file with an unsupported file type was chosen.
  Future<fs.File?> pickImportRidersDataSource();

  /// Pick a profile image from the given [source].
  /// Returns the [fs.File] that was chosen.
  Future<fs.File?> pickProfileImage(ImageSource source);
}
