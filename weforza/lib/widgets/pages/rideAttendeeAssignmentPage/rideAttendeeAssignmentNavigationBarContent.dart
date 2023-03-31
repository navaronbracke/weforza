import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeNavigationBarDisplayMode.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentNavigationBarContent extends StatelessWidget {
  RideAttendeeAssignmentNavigationBarContent({
    @required this.title,
    @required this.scanTitle,
    @required this.onStartScan,
    @required this.onSubmit,
    @required this.stream,
  }): assert(
    title != null && scanTitle != null && onSubmit != null &&
        onStartScan != null && stream != null
  );

  final String scanTitle;
  final String title;
  final VoidCallback onStartScan;
  final VoidCallback onSubmit;
  final Stream<RideAttendeeNavigationBarDisplayMode> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RideAttendeeNavigationBarDisplayMode>(
      stream: stream,
      initialData: RideAttendeeNavigationBarDisplayMode.LIST_NO_ACTIONS,
      builder: (context,snapshot){
        switch(snapshot.data){
          case RideAttendeeNavigationBarDisplayMode.LIST_ACTIONS:
            return _buildNavbarWithListActions();
          case RideAttendeeNavigationBarDisplayMode.LIST_NO_ACTIONS:
            return _buildNavbarWithoutListActions();
          case RideAttendeeNavigationBarDisplayMode.SCAN:
            return _buildNavbarWithScanTitle();
          default: return SizedBox();
        }
      },
    );
  }

  Widget _buildNavbarWithListActions(){
    return PlatformAwareWidget(
      android: () => Row(
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
      ),
      ios: () => Row(
        children: <Widget>[
          Expanded(
            child: Center(child: Text(title,overflow: TextOverflow.ellipsis)),
          ),
          CupertinoIconButton(
              onPressedColor: ApplicationTheme.primaryColor,
              idleColor: ApplicationTheme.accentColor,
              icon: Icons.bluetooth,
              onPressed: () => onStartScan()
          ),
          SizedBox(width: 10),
          CupertinoIconButton(
            onPressedColor: ApplicationTheme.primaryColor,
            idleColor: ApplicationTheme.accentColor,
            icon: Icons.check,
            onPressed: () => onSubmit(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbarWithoutListActions()
    => Text(title,overflow: TextOverflow.ellipsis);

  Widget _buildNavbarWithScanTitle()
    => Text(scanTitle,overflow: TextOverflow.ellipsis);
}
