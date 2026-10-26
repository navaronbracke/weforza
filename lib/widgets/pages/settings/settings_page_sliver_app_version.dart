/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';

/// A sliver widget that displays the app version in the [SettingsPage].
class SettingsPageSliverAppVersion extends StatelessWidget {
  const new({required this.version, super.key});

  /// The version of the app to display.
  final String version;

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .macOS || .windows => SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const .symmetric(vertical: 32),
          child: Align(
            alignment: .bottomCenter,
            child: Builder(
              builder: (context) => Text(
                '${S.of(context).version} $version',
                style: TextTheme.of(context).bodySmall?.copyWith(fontStyle: .italic),
              ),
            ),
          ),
        ),
      ),
      .iOS => SliverToBoxAdapter(
        child: CupertinoFormSection.insetGrouped(
          children: [
            CupertinoFormRow(
              prefix: Builder(builder: (context) => Text(S.of(context).version)),
              child: Text(version),
            ),
          ],
        ),
      ),
    };
  }
}
