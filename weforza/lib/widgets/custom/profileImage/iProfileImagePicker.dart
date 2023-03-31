import 'dart:io';

///This class defines a contract for picking profile images.
abstract class IProfileImagePicker {

  ///Get the picking stream.
  Stream<bool> get stream;
  ///Get the selected image.
  File get selectedImage;
  ///Pick a profile image.
  void pickProfileImage();

  ///Clear the selected image.
  void clearSelectedImage();
}