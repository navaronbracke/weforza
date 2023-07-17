import 'dart:io';

import 'package:weforza/native_service/native_service.dart';

/// This class defines an interface that allows working with the underlying file provider.
abstract base class FileStorageDelegate extends NativeService {
  const FileStorageDelegate();

  /// Whether the application uses scoped storage,
  /// which limits the access to top-level directories.
  Future<bool> hasScopedStorage();

  /// Register the given [file] as a new document.
  ///
  /// Throws if the file is empty or an invalid format.
  Future<void> registerDocument(File file);

  /// Request permission to write to external storage.
  ///
  /// This permission only has an effect on Android 9 and lower,
  /// where Scoped Storage is not in effect.
  Future<bool> requestWriteExternalStoragePermission();
}
