import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class LoadableProfileImage extends StatelessWidget {
  LoadableProfileImage({
    this.size = 40,
    @required this.image,
    @required this.onError,
    @required this.onDone,
  }): assert(size != null && size > 0.0 && image != null);

  final double size;
  final Future<File> image;
  final Widget Function(double size) onError;
  final Widget Function(double size, File image) onDone;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: image,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return snapshot.hasError ? onError(size): onDone(size, snapshot.data);
        }else{
          return SizedBox(
            width: size,
            height: size,
            child: Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          );
        }
      },
    );
  }
}
