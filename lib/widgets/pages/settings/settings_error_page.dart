/// @docImport 'package:weforza/model/settings/settings.dart';
/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:weforza/widgets/pages/settings/settings_page_sliver_navigation_bar.dart';

/// The error page for a [SettingsPage] layout, in case the [Settings] failed to load.
class SettingsErrorPage extends StatelessWidget {
  const new({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => CustomScrollView(
        controller: scrollController,
        slivers: [
          ?SettingsPageSliverNavigationBar.buildForConstraints(constraints),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                crossAxisAlignment: .stretch,
                mainAxisAlignment: .center,
                children: [_buildReloadSettingsButton()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
