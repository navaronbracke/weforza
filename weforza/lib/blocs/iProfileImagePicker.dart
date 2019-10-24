import 'dart:io';

///This class defines a contract for picking profile images.
abstract class IProfileImagePicker {

  ///Pick a profile image.
  void pickProfileImage();
  ///Get the selected image.
  File getImage();
}