import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';


class RideAttendeeAssignmentPage extends StatefulWidget {
  RideAttendeeAssignmentPage(this.ride): assert(ride != null);

  final Ride ride;

  @override
  _RideAttendeeAssignmentPageState createState() => _RideAttendeeAssignmentPageState();
}

class _RideAttendeeAssignmentPageState extends State<RideAttendeeAssignmentPage> implements PlatformAwareWidget {
  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(S.of(context).RideAttendeeAssignmentTitle),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.bluetooth),
                onPressed: (){
                  //TODO update streambuilder and start scanning
                },
              ),
            ],
            expandedHeight: 120,
            bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(widget.ride.getFormattedDate(context),style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600)),
                ),
                preferredSize: Size.fromHeight(60),
            ),
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context,int index){
              return ListTile(
                title: Text("$index"),
              );
            },childCount: 20),
          ),
          //TODO list
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return null;
  }
}
