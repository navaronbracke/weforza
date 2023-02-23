import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list_page.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_page.dart';
import 'package:weforza/widgets/pages/settings/settings_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// The home page of the application.
/// This page provides access to the ride list page, the riders list page
/// and the settings page.
///
/// By default the ride list page is shown.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late PageController _pageController;

  final _pages = [
    const RideListPage(),
    const RiderListPage(),
    const SettingsPage(),
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
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidWidget,
      ios: _buildIosWidget,
    );
  }

  Widget _buildPageView(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (page) {
        // When switching pages in the page view, the old page gives up focus.
        // The riders list page has a search field,
        // and the settings page has several text fields.
        // Only the ride list page has nothing that can have keyboard focus.
        if (_selectedIndex != 0) {
          FocusScope.of(context).unfocus();
        }

        setState(() {
          _selectedIndex = page;
        });
      },
      children: _pages,
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildPageView(context),
      bottomNavigationBar: Theme(
        data: ThemeData(
          // The NavigationBar needs Material 3 to style its selected icon properly.
          useMaterial3: true,
          navigationBarTheme: Theme.of(context).navigationBarTheme,
        ),
        child: NavigationBar(
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.directions_bike),
              label: S.of(context).rides,
            ),
            NavigationDestination(
              icon: const Icon(Icons.people),
              label: S.of(context).riders,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings),
              label: S.of(context).settings,
            ),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: <Widget>[
          Expanded(child: _buildPageView(context)),
          CupertinoTabBar(
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.directions_bike),
                label: S.of(context).rides,
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.person_2_fill),
                label: S.of(context).riders,
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.settings),
                label: S.of(context).settings,
              ),
            ],
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          )
        ],
      ),
    );
  }
}
