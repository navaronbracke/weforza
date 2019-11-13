import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';
import 'package:weforza/widgets/pages/rideList/rideListPage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/i18n.dart';

///This [Widget] represents the app landing page.
///It allows navigating between [RideListPage] and [MemberListPage].
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

///This is the [State] class for [HomePage].
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin implements PlatformAwareWidget {

  ///The tabs for this page.
  final List<Widget> _tabs = List.of([RideListPage(),MemberListPage()]);
  ///The selected index.
  int _selectedIndex = 0;
  ///The page controller for android.
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _tabs,
        controller: _pageController,
        onPageChanged: (page){
          setState(() {_selectedIndex = page; });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index){
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300),curve: Curves.easeInOut);
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
    return CupertinoTabScaffold(
      tabBuilder: (context,index){
        return _tabs[index];
      },
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
          ),
        ],
      ),
    );
  }
}