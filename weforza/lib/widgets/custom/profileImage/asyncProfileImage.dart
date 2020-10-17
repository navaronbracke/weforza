import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

/// This widget asynchronously loads a given profile image.
/// When the image could not be loaded, the given initials are displayed.
class AsyncProfileImage extends StatelessWidget {
  AsyncProfileImage({
    this.personInitials,
    @required this.icon,
    @required this.future,
    this.size = 40
  }): assert(
    icon != null && size != null && size > 0 && future != null
        && personInitials == null || personInitials.isNotEmpty
  );

  final Future<File> future;
  final String personInitials;
  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: future,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError || snapshot.data == null){
            return ProfileImage(
              icon: icon,
              image: null,
              size: size,
              personInitials: personInitials,
            );
          }

          return ProfileImage(
            icon: icon,
            image: snapshot.data,
            size: size,
            personInitials: personInitials,
          );
        }else{
          return SizedBox(
            width: size,
            height: size,
            child: Center(
                child: PlatformAwareLoadingIndicator()
            ),
          );
        }
      },
    );
  }
}
