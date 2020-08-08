
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';

class SelectableProfileIcon extends StatefulWidget {
  SelectableProfileIcon({
    @required this.future,
    @required this.onSelectedChanged,
    @required this.errorBuilder,
    @required this.imageBuilder,
    @required this.loadingBuilder,
  }): assert(
    future != null && imageBuilder != null && loadingBuilder != null &&
        onSelectedChanged != null && errorBuilder != null
  );

  final Future<File> future;
  final ValueNotifier<bool> onSelectedChanged;
  final Widget Function(double size) errorBuilder;
  final Widget Function(double size) loadingBuilder;
  final Widget Function(double size) imageBuilder;

  @override
  _SelectableProfileIconState createState() => _SelectableProfileIconState();
}

class _SelectableProfileIconState extends State<SelectableProfileIcon> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.onSelectedChanged,
      builder: (context, value, child){
        return LayoutBuilder(
            builder: (context, constraints){
              final size = constraints.biggest.shortestSide;
              return value ? SizedBox.expand(
                child: Center(
                  child: Icon(
                      Icons.done,
                      size: constraints.biggest.shortestSide * .8,
                      color: ApplicationTheme.primaryColor
                  ),
                ),
              ): FutureBuilder<File>(
                future: widget.future,
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return snapshot.hasError ? widget.errorBuilder(size):
                    widget.imageBuilder(size);
                  }else{
                    return widget.loadingBuilder(size);
                  }
                },
              );
            }
        );
      },
    );
  }
}
