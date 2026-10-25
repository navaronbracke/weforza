import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weforza/model/image/pick_image_delegate.dart';

/// This delegate provides an interface for selecting profile images.
class ProfileImagePickerDelegate {
  new({required this.imagePickerDelegate, required Uri? initialValue})
    : _notifier = ValueNotifier(AsyncData(initialValue));

  /// The delegate that will handle picking images.
  final PickImageDelegate imagePickerDelegate;

  /// The notifier that manages the selected [Uri].
  final ValueNotifier<AsyncValue<Uri?>> _notifier;

  bool _isDisposed = false;

  /// Get the selected image [Uri].
  AsyncValue<Uri?> get selectedImage => _notifier.value;

  /// Get the [ValueListenable] of selection changes.
  ValueListenable<AsyncValue<Uri?>> get listenable => _notifier;

  /// Clear the selected image.
  void clear() {
    _notifier.value = const AsyncData(null);
  }

  /// Select a new profile image from the device gallery.
  void selectProfileImageFromGallery() {
    _selectProfileImage(.gallery);
  }

  /// Take a new photo to use as profile image.
  void takePhoto() => _selectProfileImage(.camera);

  /// Select a new profile image from the given [source].
  void _selectProfileImage(ImageSource source) async {
    try {
      final previousUri = switch (_notifier.value) {
        AsyncLoading<Uri?>() || AsyncError<Uri?>() => null,
        AsyncData<Uri?>(:final value) => value,
      };

      _notifier.value = const AsyncLoading();

      final Uri? uri = await imagePickerDelegate.pickProfileImage(source);

      if (_isDisposed) {
        return;
      }

      // If the result is null, but there was a previous uri,
      // use the previous uri as result.
      if (previousUri != null && uri == null) {
        _notifier.value = AsyncData(previousUri);

        return;
      }

      _notifier.value = AsyncData(uri);
    } catch (error, stackTrace) {
      if (_isDisposed) {
        return;
      }

      _notifier.value = AsyncError(error, stackTrace);
    }
  }

  /// Dispose of this delegate.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _notifier.dispose();
  }
}
