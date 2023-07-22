import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:weforza/native_service/file_storage_delegate.dart';

final class IoFileStorageDelegate extends FileStorageDelegate {
  const IoFileStorageDelegate();

  @override
  Future<bool> hasScopedStorage() async {
    if (Platform.isAndroid) {
      return await methodChannel.invokeMethod<bool>('hasScopedStorage') ?? false;
    }

    return false;
  }

  @override
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

  @override
  Future<bool> requestExternalStoragePermission({bool read = false, bool write = false}) async {
    final bool? result = await methodChannel.invokeMethod<bool>(
      'requestExternalStoragePermission',
      <String, Object?>{
        'read': read,
        'write': write,
      },
    );

    return result ?? false;
  }

  @override
  Future<Uri?> registerImage(File file) async {
    final String mimeType = lookupMimeType(file.path) ?? '';
    final int fileSize = file.lengthSync();

    if (fileSize == 0) {
      throw ArgumentError.value(fileSize, 'fileSize', 'An empty file cannot be registered as an image.');
    }

    if (!mimeType.startsWith('image/')) {
      throw ArgumentError.value(mimeType, 'mimeType', 'Only images can be registered in the image provider.');
    }

    final String? result = await methodChannel.invokeMethod<String>(
      'registerImage',
      {
        'filePath': file.path,
        'fileName': basename(file.path),
        'fileSize': fileSize,
        'fileType': mimeType,
      },
    );

    return Uri.tryParse(result ?? '');
  }
}
