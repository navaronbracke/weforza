import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/model/image/pick_image_delegate.dart';

/// This delegate provides an interface for selecting profile images.
class ProfileImagePickerDelegate {
  ProfileImagePickerDelegate({
    required this.imagePickerDelegate,
    required Uri? initialValue,
  }) : _controller = BehaviorSubject.seeded(AsyncValue.data(initialValue));

  /// The delegate that will handle picking images.
  final PickImageDelegate imagePickerDelegate;

  /// The controller that manages the selected [Uri].
  final BehaviorSubject<AsyncValue<Uri?>> _controller;

  /// Get the selected image [Uri].
  AsyncValue<Uri?> get selectedImage => _controller.value;

  /// Get the [Stream] of selection changes.
  Stream<AsyncValue<Uri?>> get stream => _controller;

  /// Clear the selected image.
  void clear() {
    _controller.add(const AsyncValue.data(null));
  }

  /// Select a new profile image from the device gallery.
  void selectProfileImageFromGallery() {
    _selectProfileImage(ImageSource.gallery);
  }

  /// Take a new photo to use as profile image.
  void takePhoto() => _selectProfileImage(ImageSource.camera);

  /// Select a new profile image from the given [source].
  void _selectProfileImage(ImageSource source) async {
    try {
      final previousUri = _controller.value.valueOrNull;

      _controller.add(const AsyncLoading());

      final Uri? uri = await imagePickerDelegate.pickProfileImage(source);

      if (_controller.isClosed) {
        return;
      }

      // If the result is null, but there was a previous uri,
      // use the previous uri as result.
      if (previousUri != null && uri == null) {
        _controller.add(AsyncValue.data(previousUri));

        return;
      }

      _controller.add(AsyncValue.data(uri));
    } catch (error, stackTrace) {
      if (!_controller.isClosed) {
        _controller.add(AsyncValue.error(error, stackTrace));
      }
    }
  }

  /// Dispose of this delegate.
  void dispose() {
    _controller.close();
  }
}
