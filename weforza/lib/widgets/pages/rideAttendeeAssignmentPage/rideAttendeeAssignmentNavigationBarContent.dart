import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentNavigationBarContent extends StatelessWidget {
  RideAttendeeAssignmentNavigationBarContent({
    @required this.title,
    @required this.onStartScan,
    @required this.onSubmit,
    @required this.stream,
  }): assert(
    title != null && onSubmit != null && onStartScan != null && stream != null
  );

  final String title;
  final VoidCallback onStartScan;
  final VoidCallback onSubmit;
  final Stream<bool> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: stream,
      initialData: false,
      builder: (context,snapshot){
        return PlatformAwareWidget(
          android: () => _buildAndroidLayout(context,snapshot.data),
          ios: () => _buildIosLayout(context,snapshot.data),
        );
      },
    );
  }

  Widget _buildAndroidLayout(BuildContext context, bool hasActions){
    return hasActions ? Row(
      children: <Widget>[
        Expanded(
          child: Text(title,overflow: TextOverflow.ellipsis),
        ),
        IconButton(
          icon: Icon(Icons.bluetooth),
          onPressed: () => onStartScan(),
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () => onSubmit(),
        )
      ],
    ): Text(title,overflow: TextOverflow.ellipsis);
  }

  Widget _buildIosLayout(BuildContext context, bool hasActions){
    return hasActions ? Row(
      children: <Widget>[
        Expanded(
          child: Center(child: Text(title,overflow: TextOverflow.ellipsis)),
        ),
        CupertinoIconButton(
            icon: Icons.bluetooth,
            onPressed: () => onStartScan()
        ),
        SizedBox(width: 10),
        CupertinoIconButton(
          icon: Icons.check,
          onPressed: () => onSubmit(),
        ),
      ],
    ): Text(title,overflow: TextOverflow.ellipsis);
  }
}
