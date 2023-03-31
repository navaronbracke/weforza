
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';

class SelectableProfileImage extends StatefulWidget {
  SelectableProfileImage({
    @required this.future,
    @required this.onSelectedChanged,
    @required this.errorBuilder,
    @required this.imageBuilder,
    @required this.loadingBuilder,
    @required this.size,
  }): assert(
    future != null && imageBuilder != null && loadingBuilder != null &&
        onSelectedChanged != null && errorBuilder != null && size != null && size > 0.0
  );

  final Future<File> future;
  final ValueNotifier<bool> onSelectedChanged;
  final Widget Function(double size) errorBuilder;
  final Widget Function(double size) loadingBuilder;
  final Widget Function(double size, File image) imageBuilder;
  final double size;

  @override
  _SelectableProfileImageState createState() => _SelectableProfileImageState();
}

class _SelectableProfileImageState extends State<SelectableProfileImage> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.onSelectedChanged,
      builder: (context, value, child){
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: value ? Icon(
                Icons.done,
                size: widget.size * .8,
                color: ApplicationTheme.primaryColor
            ): FutureBuilder<File>(
              future: widget.future,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return snapshot.hasError ? widget.errorBuilder(widget.size):
                  widget.imageBuilder(widget.size, snapshot.data);
                }else{
                  return widget.loadingBuilder(widget.size);
                }
              },
            )
          ),
        );
      },
    );
  }
}
