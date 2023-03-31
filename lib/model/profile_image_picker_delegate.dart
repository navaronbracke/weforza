import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/file/file_handler.dart';

/// This delegate provides an interface for selecting profile images.
class ProfileImagePickerDelegate {
  ProfileImagePickerDelegate({
    required this.fileHandler,
    required File? initialValue,
  }) : _controller = BehaviorSubject.seeded(AsyncValue.data(initialValue));

  /// The file handler for this delegate.
  final FileHandler fileHandler;

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

  /// Select a new image from the photo gallery.
  void selectImageFromGallery() async {
    try {
      _controller.add(const AsyncLoading());

      final file = await fileHandler.chooseProfileImageFromGallery();

      if (!_controller.isClosed) {
        _controller.add(AsyncValue.data(file));
      }
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
