import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';
import 'package:weforza/widgets/pages/rideList/rideListPage.dart';
import 'package:weforza/widgets/pages/settings/settingsPage.dart';
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

  final _pages = [RideListPage(),MemberListPage(),SettingsPage()];

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

  Widget _buildPageView(){
    return PageView(
      children: _pages,
      controller: _pageController,
      onPageChanged: (page){
        setState(() {_selectedIndex = page; });
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
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
          BottomNavigationBarItem(
            title: Text(S.of(context).HomePageSettingsTab),
            icon: Icon(Icons.settings),
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
            child: _buildPageView(),
          ),
          CupertinoTabBar(
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.directions_bike)),
              BottomNavigationBarItem(icon: Icon(Icons.people)),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings)),
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