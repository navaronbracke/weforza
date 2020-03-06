import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePickingState.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

///This class represents a [Widget] for selecting a profile picture.
class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker({@required this.imageHandler, @required this.errorMessage, @required this.size}):
        assert(imageHandler != null && size != null && errorMessage != null);

  ///This handler will handle picking an image.
  final IProfileImagePicker imageHandler;
  ///The size for a selected image.
  final double size;
  ///An error message to display when the image couldn't be loaded.
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileImagePickingState>(
      initialData: ProfileImagePickingState.IDLE,
      stream: imageHandler.stream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Center(child: Text(errorMessage,softWrap: true));
        }else{
          return snapshot.data == ProfileImagePickingState.LOADING ? SizedBox(
            width: size,
            height: size,
            child: Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          ): GestureDetector(
              child: ProfileImage(
                image: imageHandler.selectedImage,
                size: size,
                icon: Icons.camera_alt,
              ),
              onTap: () => imageHandler.pickProfileImage(),
              onLongPress: () => imageHandler.clearSelectedImage(),
          );
        }
      },
    );
  }
}