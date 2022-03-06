import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker({
    Key? key,
    required this.errorMessage,
    required this.size,
    required this.fileHandler,
    required this.onClearSelectedImage,
    required this.setSelectedImage,
    required this.initialImage,
  })  : assert(size > 0 && errorMessage.isNotEmpty && errorMessage.isNotEmpty),
        super(key: key);

  final double size;
  final String errorMessage;
  final IFileHandler fileHandler;
  final void Function() onClearSelectedImage;
  final void Function(Future<File?> image) setSelectedImage;
  final Future<File?> initialImage;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final _imageController = BehaviorSubject<_SelectProfileImageState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_SelectProfileImageState>(
      stream: _imageController.stream,
      initialData: _SelectProfileImageState(
        image: widget.initialImage,
        isSelecting: false,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(widget.errorMessage, softWrap: true));
        } else {
          return snapshot.data!.isSelecting
              ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const Center(
                    child: PlatformAwareLoadingIndicator(),
                  ),
                )
              : GestureDetector(
                  child: PlatformAwareWidget(
                    android: () => AsyncProfileImage(
                      future: snapshot.data!.image,
                      icon: Icons.camera_alt,
                      size: widget.size,
                    ),
                    ios: () => AsyncProfileImage(
                      future: snapshot.data!.image,
                      icon: CupertinoIcons.camera_fill,
                      size: widget.size,
                    ),
                  ),
                  onTap: pickProfileImage,
                  onLongPress: clearSelectedImage,
                );
        }
      },
    );
  }

  void pickProfileImage() async {
    _imageController.add(
        _SelectProfileImageState(image: Future.value(null), isSelecting: true));
    await widget.fileHandler
        .chooseProfileImageFromGallery()
        .then((File? image) {
      final future = Future.value(image);
      widget.setSelectedImage(future);
      _imageController
          .add(_SelectProfileImageState(image: future, isSelecting: false));
    }).catchError((e) {
      _imageController.addError(e);
    });
  }

  void clearSelectedImage() {
    _imageController.add(
        _SelectProfileImageState(image: Future.value(null), isSelecting: true));
    widget.onClearSelectedImage();
    _imageController.add(_SelectProfileImageState(
        image: Future.value(null), isSelecting: false));
  }

  @override
  void dispose() {
    _imageController.close();
    super.dispose();
  }
}

/// This wrapper is used by [ProfileImagePicker] for wrapping the selection state.
class _SelectProfileImageState {
  _SelectProfileImageState({required this.image, required this.isSelecting});

  /// Whether the user is still busy selecting an image.
  final bool isSelecting;

  /// The Future that resolves to the selected File.
  /// The File from this Future can be null.
  final Future<File?> image;
}
