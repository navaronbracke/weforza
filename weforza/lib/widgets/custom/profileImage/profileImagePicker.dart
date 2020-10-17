import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/widgets/custom/profileImage/asyncProfileImage.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker({
    @required this.errorMessage,
    @required this.size,
    @required this.fileHandler,
    @required this.onClearSelectedImage,
    @required this.setSelectedImage,
    @required this.initialImage,
  }): assert(
    size != null && size > 0 && errorMessage != null && errorMessage.isNotEmpty
        && initialImage != null && onClearSelectedImage != null
        && setSelectedImage != null && errorMessage.isNotEmpty
        && fileHandler != null
  );

  final double size;
  final String errorMessage;
  final IFileHandler fileHandler;
  final void Function() onClearSelectedImage;
  final void Function(Future<File> image) setSelectedImage;
  final Future<File> initialImage;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  StreamController<_SelectProfileImageState> _imageController = BehaviorSubject();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_SelectProfileImageState>(
      stream: _imageController.stream,
      initialData: _SelectProfileImageState(
          image: widget.initialImage,
          isSelecting: false
      ),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Center(child: Text(widget.errorMessage,softWrap: true));
        }else{
          return snapshot.data.isSelecting ? SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          ): GestureDetector(
            child: AsyncProfileImage(
              future: snapshot.data.image,
              icon: Icons.camera_alt,
              size: widget.size,
            ),
            onTap: pickProfileImage,
            onLongPress: clearSelectedImage,
          );
        }
      },
    );
  }

  void pickProfileImage() async {
    _imageController.add(_SelectProfileImageState(image: Future.value(null), isSelecting: true));
    await widget.fileHandler.chooseProfileImageFromGallery().then((File image){
      final future = Future.value(image);
      widget.setSelectedImage(future);
      _imageController.add(_SelectProfileImageState(image: future, isSelecting: false));
    }).catchError(_imageController.addError);
  }

  void clearSelectedImage() {
    _imageController.add(_SelectProfileImageState(image: Future.value(null), isSelecting: true));
    widget.onClearSelectedImage();
    _imageController.add(_SelectProfileImageState(image: Future.value(null), isSelecting: false));
  }

  @override
  void dispose() {
    _imageController.close();
    super.dispose();
  }
}

/// This wrapper is used by [ProfileImagePicker] for wrapping the selection state.
class _SelectProfileImageState {
  _SelectProfileImageState({
    @required this.image,
    @required this.isSelecting
  }): assert(image != null && isSelecting != null);

  /// Whether the user is still busy selecting an image.
  final bool isSelecting;
  /// The Future that resolves to the selected File.
  /// The File from this Future can be null.
  final Future<File> image;
}
