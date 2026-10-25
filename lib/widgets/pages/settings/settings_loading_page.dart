/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/pages/settings/settings_page_sliver_navigation_bar.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// The loading page for a [SettingsPage] layout.
class SettingsLoadingPage extends StatelessWidget {
  const new({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => CustomScrollView(
        controller: scrollController,
        slivers: [
          ?SettingsPageSliverNavigationBar.buildForConstraints(constraints),
          const SliverFillRemaining(hasScrollBody: false, child: Center(child: PlatformAwareLoadingIndicator())),
        ],
      ),
    );
  }
}
