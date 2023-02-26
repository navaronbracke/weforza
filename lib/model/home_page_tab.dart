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

  factory HomePageTab.fromIndex(int index) {
    switch (index) {
      case 0:
        return ridesList;
      case 1:
        return riderList;
      case 2:
        return settings;
      default:
        throw ArgumentError.value(index);
    }
  }

  /// The index of this tab among all the tabs.
  final int pageIndex;

  /// Whether this tab should resize to avoid the bottom view inset.
  final bool resizeToAvoidBottomInset;
}
