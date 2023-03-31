import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/profileImage/asyncProfileImage.dart';
import 'package:weforza/widgets/custom/profileImage/selectProfileImageState.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

///This class represents a [Widget] for selecting a profile picture.
class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker({
    @required this.errorMessage,
    @required this.size,
    @required this.selectImage,
    @required this.clear,
    @required this.stream
  }): assert(
    size != null && size > 0 && errorMessage != null && stream != null
        && selectImage != null && clear != null
  );

  ///The size for a selected image.
  final double size;
  ///An error message to display when the image couldn't be loaded.
  final String errorMessage;
  ///This function is called when the selected image should be cleared.
  final void Function() clear;
  ///This function is called when an image selection is requested.
  final void Function() selectImage;

  final Stream<SelectProfileImageState> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectProfileImageState>(
      initialData: SelectProfileImageState(
          image: Future.value(null),
          isSelecting: false
      ),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Center(child: Text(errorMessage,softWrap: true));
        }else{
          return snapshot.data.isSelecting ? SizedBox(
            width: size,
            height: size,
            child: Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          ): GestureDetector(
            child: AsyncProfileImage(
              future: snapshot.data.image,
              icon: Icons.camera_alt,
              size: size,
            ),
            onTap: selectImage,
            onLongPress: clear,
          );
        }
      },
    );
  }
}