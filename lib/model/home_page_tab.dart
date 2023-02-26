/// This enum defines the different home page tabs.
enum HomePageTab {
  /// The rides list tab. This is the first tab. This tab is shown by default.
  rides(0),

  /// The riders list tab. This is the second tab.
  riders(1),

  /// The settings tab. This is the third and last tab.
  settings(2);

  const HomePageTab(this.tabIndex);

  factory HomePageTab.fromIndex(int index) {
    switch (index) {
      case 0:
        return rides;
      case 1:
        return riders;
      case 2:
        return settings;
      default:
        throw RangeError.index(index, HomePageTab.values);
    }
  }

  /// The index of this tab among all the tabs.
  final int tabIndex;
}
