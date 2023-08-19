import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:file/file.dart' as fs;
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
  Future<void> registerDocument(fs.File file) async {
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
  Future<bool> requestWriteExternalStoragePermission() async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('External storage is only supported on Android.');
    }

    final bool? result = await methodChannel.invokeMethod<bool>('requestWriteExternalStoragePermission');

    return result ?? false;
  }

  @override
  Future<Uri?> registerImage(fs.File file) async {
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

  @override
  Future<Uint8List> getBytesFromContentUri(Uri uri) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('Loading a "content://" Uri is only supported on Android.');
    }

    if (!uri.isScheme('content')) {
      throw ArgumentError.value(uri, 'uri', 'Only "content://" Uris are supported.');
    }

    final Uint8List? bytes = await methodChannel.invokeMethod<Uint8List>('getBytesFromContentUri', {
      'contentUri': uri.toString(),
    });

    if (bytes == null) {
      throw ArgumentError.notNull('bytes');
    }

    return bytes;
  }
}
