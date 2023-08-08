import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/native_service/file_storage_delegate.dart';

/// Decodes the given `content://` [Uri] as an image,
/// associating it with the given scale.
@immutable
final class ContentUriImage extends ImageProvider<ContentUriImage> {
  /// Creates a new [ContentUriImage] from the given [uri].
  ContentUriImage({
    required this.fileStorageDelegate,
    required this.uri,
    this.scale = 1.0,
  }) : assert(uri.isScheme('content'), "Only 'content://' Uris are supported.");

  /// The delegate that will load the image.
  final FileStorageDelegate fileStorageDelegate;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// The content [Uri] to load.
  final Uri uri;

  Future<Codec> _loadAsync(ContentUriImage key, {required ImageDecoderCallback decode}) async {
    assert(key == this, 'ContentUriImage key is not equal to the caller object.');

    try {
      final Uint8List bytes = await fileStorageDelegate.getBytesFromContentUri(key.uri);

      if (bytes.isEmpty) {
        throw StateError('The image at the given Uri "$uri" is empty and cannot be loaded as an image.');
      }

      return decode(await ImmutableBuffer.fromUint8List(bytes));
    } catch (exception) {
      PaintingBinding.instance.imageCache.evict(key);

      rethrow;
    }
  }

  @override
  ImageStreamCompleter loadImage(ContentUriImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode: decode),
      scale: key.scale,
      debugLabel: key.uri.toString(),
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Uri: ${key.uri}'),
      ],
    );
  }

  @override
  Future<ContentUriImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ContentUriImage>(this);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ContentUriImage && other.uri == uri && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(uri, scale);

  @override
  String toString() => 'ContentUriImage("$uri", scale: $scale)';
}
