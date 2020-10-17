
import 'dart:io';
import 'package:meta/meta.dart';

/// This wrapper is used by ProfileImagePicker for wrapping the selection state.
class SelectProfileImageState {
  SelectProfileImageState({
    @required this.image,
    @required this.isSelecting
}): assert(image != null && isSelecting != null);

  /// Whether the user is still busy selecting an image.
  final bool isSelecting;
  /// The Future that resolves to the selected File.
  /// The File from this Future can be null.
  final Future<File> image;
}