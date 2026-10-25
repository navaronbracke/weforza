import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:weforza/generated/l10n.dart';

class SettingsPageSliverNavigationBar extends StatelessWidget {
  const new({super.key});

  /// Build the sliver navigation bar for the settings page.
  ///
  /// Returns a [CupertinoSliverNavigationBar] for [TargetPlatform.iOS].
  /// Returns `null` for other platforms.
  static Widget? buildForConstraints(BoxConstraints constraints) {
    // The navigation bar is only included on iOS, because it grows as the user scrolls, up to a fixed size.
    // Other platforms defer to a fixed app bar.
    return switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .macOS || .windows => null,
      .iOS => const SettingsPageSliverNavigationBar(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      border: null,
      largeTitle: Text(S.of(context).settings),
      transitionBetweenRoutes: false,
    );
  }
}
