import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentEmpty.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget displays the manual attendee assignment overview.
///It presents the members in a list and shows whether they are attending the ride that was selected.
///It provides the option to start scanning and to save the selection.
class RideAttendeeAssignmentList extends StatelessWidget implements PlatformAwareWidget {
  RideAttendeeAssignmentList(this.title,this.items,this.onStartScan,this.onSave):
        assert(title != null && items != null && onStartScan != null && onSave != null);

  final String title;

  final List<RideAttendeeAssignmentItemBloc> items;

  final VoidCallback onStartScan;

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,style: TextStyle(fontSize: 16)),
        actions: items.isEmpty ? [] : <Widget>[
          IconButton(
              icon: Icon(Icons.bluetooth),
              onPressed: onStartScan,
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: onSave,
          ),
        ],
      ),
      body: items.isEmpty ? RideAttendeeAssignmentEmpty() :
      ListView.builder(itemBuilder: (context,index){
        return RideAttendeeAssignmentItem(items[index]);
      }, itemCount: items.length),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoIconButton(
                Icons.bluetooth,
                CupertinoTheme.of(context).primaryColor,
                CupertinoTheme.of(context).primaryContrastingColor,
                onStartScan
            ),
            SizedBox(width: 30),
            CupertinoIconButton(
                Icons.check,
                CupertinoTheme.of(context).primaryColor,
                CupertinoTheme.of(context).primaryContrastingColor,
                onSave
            ),
          ],
        ),
      ),
      child: items.isEmpty ? RideAttendeeAssignmentEmpty() :
      ListView.builder(itemBuilder: (context,index){
        return RideAttendeeAssignmentItem(items[index]);
      }, itemCount: items.length),
    );
  }
}
