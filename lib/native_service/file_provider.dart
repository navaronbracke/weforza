import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:weforza/native_service/native_service.dart';

/// This class represents a service that provides a mechanism
/// to register new files in the underlying file provider.
final class FileProvider extends NativeService {
  const FileProvider();

  /// Whether the application uses Scoped Storage.
  /// This only has an effect on Android.
  Future<bool> hasScopedStorage() async {
    if (Platform.isAndroid) {
      return await methodChannel.invokeMethod<bool>('hasScopedStorage') ?? false;
    }

    return false;
  }

  /// Register the given [file] as a new document.
  ///
  /// Throws if the file is empty or an invalid format.
  Future<void> registerDocument(File file) async {
    final String? mimeType = lookupMimeType(file.path);
    final int fileSize = file.lengthSync();

    if (fileSize == 0) {
      throw ArgumentError.value(fileSize, 'fileSize', 'An empty file cannot be registered as a document.');
    }

    switch (mimeType) {
      case 'application/json':
      case 'text/csv':
        await methodChannel.invokeMethod<void>(
          'registerDocument',
          {
            'filePath': file.path,
            'fileName': basename(file.path),
            'fileSize': fileSize,
            'fileType': mimeType,
          },
        );
      default:
        throw ArgumentError.value(
          mimeType,
          'mimeType',
          'The given MIME type, $mimeType is not a supported document type.',
        );
    }
  }

  /// Request permission to write to external storage.
  ///
  /// This permission only has an effect on Android 9 and lower, where Scoped Storage is not in effect.
  Future<bool> requestWriteExternalStoragePermission() async {
    final bool? result = await methodChannel.invokeMethod<bool>(
      'requestWriteExternalStoragePermission',
    );

    return result ?? false;
  }
}
