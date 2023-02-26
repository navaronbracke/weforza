import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/home_page_tab.dart';
import 'package:weforza/widgets/pages/home_page/home_page_app_bar.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list.dart';
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
  HomePageTab _selectedTab = HomePageTab.rides;

  void _onNavigationDestinationSelected(BuildContext context, int index) {
    if (_selectedTab.tabIndex == index) {
      return;
    }

    // When switching pages, the old page gives up focus.
    // The riders list page has a search field,
    // and the settings page has several text fields.
    // Only the ride list page has nothing that can have keyboard focus.
    if (_selectedTab != HomePageTab.rides) {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      _selectedTab = HomePageTab.fromIndex(index);
    });
  }

  Widget _buildPage(BuildContext context) {
    // TODO
    /*
    const List<Widget> pages = [
      RideList(),
      RiderList(),
      SettingsPage(),
    ];*/

    return pages[_selectedTab.tabIndex];
  }

  Widget _buildAndroidWidget(BuildContext context) {
    final translator = S.of(context);

    return Scaffold(
      appBar: HomePageAppBar(selectedTab: _selectedTab),
      resizeToAvoidBottomInset: false,
      body: _buildPage(context),
      bottomNavigationBar: Theme(
        data: ThemeData(
          // The NavigationBar needs Material 3 to style its selected icon properly.
          useMaterial3: true,
          navigationBarTheme: Theme.of(context).navigationBarTheme,
        ),
        child: NavigationBar(
          selectedIndex: _selectedTab.tabIndex,
          onDestinationSelected: (index) => _onNavigationDestinationSelected(context, index),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.directions_bike),
              label: translator.rides,
            ),
            NavigationDestination(
              icon: const Icon(Icons.people),
              label: translator.riders,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings),
              label: translator.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    final translator = S.of(context);

    ObstructingPreferredSizeWidget? navigationBar;
    Color? backgroundColor;

    switch (_selectedTab) {
      case HomePageTab.riders:
      case HomePageTab.rides:
        navigationBar = HomePageCupertinoNavigationBar(selectedTab: _selectedTab);
        break;
      case HomePageTab.settings:
        // The settings page uses a CupertinoSliverNavigationBar,
        // and a different background color.
        backgroundColor = CupertinoColors.systemGroupedBackground;
        break;
    }

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      navigationBar: navigationBar,
      child: Column(
        children: <Widget>[
          Expanded(child: _buildPage(context)),
          CupertinoTabBar(
            currentIndex: _selectedTab.tabIndex,
            onTap: (index) => _onNavigationDestinationSelected(context, index),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.directions_bike),
                label: translator.rides,
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.person_2_fill),
                label: translator.riders,
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.settings),
                label: translator.settings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidWidget,
      ios: _buildIosWidget,
    );
  }
}
