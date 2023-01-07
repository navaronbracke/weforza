import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This widget represents a placeholder for the [ProfileImagePicker]
/// that displays an iOS-style grey circular shape
/// with a clipped person icon in the middle.
class CupertinoProfileImagePickerPlaceholder extends StatelessWidget {
  const CupertinoProfileImagePickerPlaceholder({
    required this.size,
    super.key,
  });

  /// The size for the placeholder.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey2,
              borderRadius: BorderRadius.all(
                Radius.circular(size / 2),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0, size / 10),
              child: Icon(
                CupertinoIcons.person_solid,
                color: CupertinoColors.white,
                size: size,
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(
                color: CupertinoColors.systemGrey2,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(size / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// This widget represents a placeholder for the [ProfileImagePicker]
/// that displays a Material-style circular shape
/// with a person icon in the middle.
class MaterialProfileImagePickerPlaceholder extends StatelessWidget {
  const MaterialProfileImagePickerPlaceholder({
    required this.size,
    super.key,
  });

  /// The size of the placeholder.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        color: Colors.grey.shade500,
      ),
      child: Center(
        child: Icon(Icons.person, color: Colors.white, size: .7 * size),
      ),
    );
  }
}
