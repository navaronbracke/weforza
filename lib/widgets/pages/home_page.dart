import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/member_list/member_list_page.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list_page.dart';
import 'package:weforza/widgets/pages/settings/settings_page.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents the app landing page.
///It allows navigating between [RideListPage] and [MemberListPage].
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

///This is the [State] class for [HomePage].
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ///The selected index.
  int _selectedIndex = 0;

  late PageController _pageController;

  final _pages = [
    const RideListPage(),
    const MemberListPage(),
    const SettingsPage()
  ];

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

  Widget _buildPageView() {
    return PageView(
      children: _pages,
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _selectedIndex = page;
        });
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_bike),
            label: S.of(context).Rides,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: S.of(context).Riders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: S.of(context).Settings,
          ),
        ],
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildPageView(),
            ),
            CupertinoTabBar(
              currentIndex: _selectedIndex,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.directions_bike),
                  label: S.of(context).Rides,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.person_2_fill),
                  label: S.of(context).Riders,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.settings),
                  label: S.of(context).Settings,
                ),
              ],
              onTap: (index) {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
            )
          ],
        ));
  }
}
