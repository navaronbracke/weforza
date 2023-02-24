import 'package:flutter/widgets.dart';

/// This widget represents the scrollview for the settings page.
class SettingsPageScrollView extends StatelessWidget {
  /// The default constructor.
  const SettingsPageScrollView({
    required this.excludedTermsList,
    required this.excludedTermsListFooter,
    required this.riderListFilter,
    required this.resetRideCalendarButton,
    required this.scanDurationOption,
    required this.scrollController,
    required this.version,
    super.key,
    this.excludedTermsListHeader,
    this.navigationBar,
  });

  /// The widget that represents the list of excluded terms.
  final Widget excludedTermsList;

  /// The widget that represents the footer for the excluded terms list.
  final Widget excludedTermsListFooter;

  /// The widget that represents the header for the excluded terms list.
  final Widget? excludedTermsListHeader;

  /// The widget that represents the rider list filter.
  final Widget riderListFilter;

  /// The sliver navigation bar that is placed first in the scrollview.
  final Widget? navigationBar;

  /// The widget that displays the reset ride calendar button.
  final Widget resetRideCalendarButton;

  /// The widget that displays the scan duration option.
  final Widget scanDurationOption;

  /// The scroll controller for the scroll view.
  final ScrollController scrollController;

  /// The widget that displays the app version information.
  final Widget version;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        if (navigationBar != null) navigationBar!,
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            riderListFilter,
            scanDurationOption,
            if (excludedTermsListHeader != null) excludedTermsListHeader!,
          ]),
        ),
        excludedTermsList,
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            excludedTermsListFooter,
            resetRideCalendarButton,
          ]),
        ),
        version,
      ],
    );
  }
}
