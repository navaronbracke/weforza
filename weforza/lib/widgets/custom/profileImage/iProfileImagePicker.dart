import 'dart:io';

import 'package:weforza/widgets/custom/profileImage/profileImagePickingState.dart';

///This class defines a contract for picking profile images.
abstract class IProfileImagePicker {

  ///Get the picking stream.
  Stream<ProfileImagePickingState> get stream;
  ///Get the selected image.
  File get selectedImage;
  ///Pick a profile image.
  void pickProfileImage();
}