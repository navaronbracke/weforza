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
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  ///The selected index.
  int _selectedIndex = 0;
  
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
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [RideListPage(),MemberListPage()],
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

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              children: [RideListPage(),MemberListPage()],
              controller: _pageController,
              onPageChanged: (page){
                setState(() {_selectedIndex = page; });
              },
            ),
          ),
          CupertinoTabBar(
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.directions_bike)),
              BottomNavigationBarItem(icon: Icon(Icons.people)),
            ],
            onTap: (index){
              _pageController.animateToPage(index, duration: const Duration(milliseconds: 300),curve: Curves.easeInOut);
            },
          )
        ],
      )
    );
  }
}