import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/pages/memberList/memberList.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'package:weforza/generated/i18n.dart';

///This [Widget] represents the app landing page.
///It allows navigating between [RideListPage] and [MemberList].
class HomePage extends StatelessWidget implements PlatformAwareWidget {

  //TODO add rides list
  final List<Widget> _tabs = List.of([MemberList()]);

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AppName),
      ),
      body: TabBarView(children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          //TODO navigate

        },
        items: [
          BottomNavigationBarItem(
            title: Text(S.of(context).HomePageRidesTab),
            icon: Icon(Icons.directions_bike),
          ),
          BottomNavigationBarItem(
            title: Text(S.of(context).HomePageMembersTab),
            icon: Icon(Icons.people),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {

    //TODO use cupertino tab scaffold

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).AppName),
      ),
      child: Center(

      ),
    );
  }

}