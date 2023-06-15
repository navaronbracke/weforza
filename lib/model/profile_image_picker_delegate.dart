import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/file/file_system.dart';

/// This delegate provides an interface for selecting profile images.
class ProfileImagePickerDelegate {
  ProfileImagePickerDelegate({
    required this.fileSystem,
    required File? initialValue,
  }) : _controller = BehaviorSubject.seeded(AsyncValue.data(initialValue));

  /// The file system for this delegate.
  final FileSystem fileSystem;

  /// The controller that manages the selected file.
  final BehaviorSubject<AsyncValue<File?>> _controller;

  /// Get the selected image.
  AsyncValue<File?> get selectedImage => _controller.value;

  /// Get the [Stream] of file selection changes.
  Stream<AsyncValue<File?>> get stream => _controller;

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
      final previousFile = _controller.value.valueOrNull;

      _controller.add(const AsyncLoading());

      final file = await fileSystem.pickProfileImage(source);

      if (_controller.isClosed) {
        return;
      }

      // If the result is null, but there was a previous file,
      // use the previous file as result.
      if (previousFile != null && file == null) {
        _controller.add(AsyncValue.data(previousFile));

        return;
      }

      _controller.add(AsyncValue.data(file));
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
