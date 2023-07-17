import 'package:file/file.dart';
import 'package:image_picker/image_picker.dart';

/// This interface defines a delegate for picking a file that is used as a profile image.
abstract interface class PickImageDelegate {
  /// Pick a profile image from the given [source].
  /// If the [source] is [ImageSource.gallery], the original file is returned.
  ///
  /// If the [source] is [ImageSource.camera], a new picture is taken using the device camera.
  /// Before taking a new picture,
  /// the necessary permissions for accessing the camera and writing to disk are requested.
  ///
  /// Returns the [File] that was chosen.
  /// Returns a [Future.error] if the permissions have been denied.
  /// Returns a [Future.error] if the device does not have a camera.
  Future<File?> pickProfileImage(ImageSource source);
}
