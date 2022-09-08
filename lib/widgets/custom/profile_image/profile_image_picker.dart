import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/profile_image_picker_delegate.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    Key? key,
    required this.delegate,
    required this.size,
  }) : super(key: key);

  final ProfileImagePickerDelegate delegate;

  final double size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectProfileImageState>(
      stream: delegate.stream,
      initialData: delegate.current,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(S.of(context).GenericError, softWrap: true),
          );
        }

        final value = snapshot.data!;

        if (value.selecting) {
          return SizedBox(
            width: size,
            height: size,
            child: const Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          );
        }

        return GestureDetector(
          onTap: delegate.pickImage,
          onLongPress: delegate.clearImage,
          child: PlatformAwareWidget(
            android: () => AsyncProfileImage(
              future: value.image,
              icon: Icons.camera_alt,
              size: size,
            ),
            ios: () => AsyncProfileImage(
              future: value.image,
              icon: CupertinoIcons.camera_fill,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
