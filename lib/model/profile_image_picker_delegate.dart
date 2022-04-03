import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/file/file_handler.dart';

/// This delegate manages selecting profile images for members.
class ProfileImagePickerDelegate {
  ProfileImagePickerDelegate({
    required this.fileHandler,
    required Future<File>? currentImage,
  })  : _image = currentImage,
        _imageController = BehaviorSubject<SelectProfileImageState>.seeded(
          SelectProfileImageState(
            image: currentImage,
            selecting: false,
          ),
        );

  /// The file handler for this delegate.
  final IFileHandler fileHandler;

  final BehaviorSubject<SelectProfileImageState> _imageController;

  /// The selected profile image.
  Future<File>? _image;

  /// Get the selected image.
  Future<File>? get image => _image;

  Stream<SelectProfileImageState> get stream => _imageController;

  SelectProfileImageState get current => _imageController.value;

  /// Clear the selected image.
  void clearImage() {
    _imageController.add(
      SelectProfileImageState(image: null, selecting: true),
    );
    _image = null;
    _imageController.add(
      SelectProfileImageState(image: _image, selecting: false),
    );
  }

  /// Set the selected image.
  void pickImage() async {
    try {
      _imageController.add(
        SelectProfileImageState(image: null, selecting: true),
      );

      final file = await fileHandler.chooseProfileImageFromGallery();

      _image = file == null ? null : Future.value(file);

      _imageController.add(
        SelectProfileImageState(image: _image, selecting: false),
      );
    } catch (error) {
      _imageController.addError(error);
    }
  }

  /// Dispose of this delegate.
  void dispose() {
    _imageController.close();
    _image = null;
  }
}

/// The selection state for a profile image picker.
class SelectProfileImageState {
  SelectProfileImageState({
    required this.image,
    required this.selecting,
  });

  /// Whether the user is still busy selecting an image.
  final bool selecting;

  /// The Future that resolves to the selected File.
  final Future<File>? image;
}
