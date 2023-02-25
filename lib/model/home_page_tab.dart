import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list_page.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_page.dart';
import 'package:weforza/widgets/pages/settings/settings_page.dart';

/// This enum defines the different tabs for the home page.
enum HomePageTab {
  /// The list of riders. This is the second tab.
  riderList(pageIndex: 1, resizeToAvoidBottomInset: false),

  /// The rides list. This is the first tab and is shown by default.
  ridesList(pageIndex: 0, resizeToAvoidBottomInset: false),

  /// The settings page. This is the third and last tab.
  settings(pageIndex: 2, resizeToAvoidBottomInset: true);

  /// The default constructor.
  const HomePageTab({required this.pageIndex, required this.resizeToAvoidBottomInset});

  factory HomePageTab.fromPageIndex(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return ridesList;
      case 1:
        return riderList;
      case 2:
        return settings;
      default:
        throw ArgumentError.value(pageIndex);
    }
  }

  /// The index of this tab among all the tabs.
  final int pageIndex;

  /// Whether this tab should resize to avoid the bottom view inset.
  final bool resizeToAvoidBottomInset;

  /// Get the list of tabs as a list of [Widget]s.
  ///
  /// This value is typically passed to the `children` of a [PageView].
  static const List<Widget> pages = [
    RideListPage(),
    RiderListPage(),
    SettingsPage(),
  ];
}
