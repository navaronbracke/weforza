import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget displays the manual attendee assignment overview.
///It presents the members in a list and shows whether they are attending the ride that was selected.
///It provides the option to start scanning and to save the selection.
class RideAttendeeAssignmentList extends StatefulWidget {
  RideAttendeeAssignmentList(this.title,this.items,this.onStartScan,this.onSave):
        assert(title != null && items != null && onStartScan != null && onSave != null);

  final String title;

  final List<RideAttendeeAssignmentItemBloc> items;

  final VoidCallback onStartScan;

  final VoidCallback onSave;

  _RideAttendeeAssignmentListState createState() => _RideAttendeeAssignmentListState();
}

class _RideAttendeeAssignmentListState extends State<RideAttendeeAssignmentList> {

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(fontSize: 16)),
        actions: widget.items.isEmpty ? [] : <Widget>[
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: widget.onStartScan,
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => widget.onSave(),
          ),
        ],
      ),
      body: widget.items.isEmpty ? Center(child: _RideAttendeeAssignmentEmpty()) :
      ListView.builder(itemBuilder: (context,index){
        return RideAttendeeAssignmentItem(widget.items[index]);
      }, itemCount: widget.items.length),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: widget.items.isEmpty ? Text(widget.title) :
        Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(widget.title)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton(
                    Icons.bluetooth,
                    CupertinoTheme.of(context).primaryColor,
                    CupertinoTheme.of(context).primaryContrastingColor,
                    widget.onStartScan
                ),
                SizedBox(width: 10),
                CupertinoIconButton(
                    Icons.check,
                    CupertinoTheme.of(context).primaryColor,
                    CupertinoTheme.of(context).primaryContrastingColor,
                    () => widget.onSave()
                ),
              ],
            ),
          ],
        ),
      ),
      child: widget.items.isEmpty ? Center(child: _RideAttendeeAssignmentEmpty()) :
      SafeArea(
        bottom: false,
        child: ListView.builder(itemBuilder: (context,index){
          return RideAttendeeAssignmentItem(widget.items[index]);
        }, itemCount: widget.items.length),
      ),
    );
  }
}

class _RideAttendeeAssignmentEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline),
        Text(S.of(context).MemberListNoItems),
      ],
    );
  }
}
