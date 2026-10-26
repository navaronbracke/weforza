/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/scan_duration_delegate.dart';
import 'package:weforza/widgets/pages/settings/scan_duration_option.dart';

/// A sliver widget for inside the [SettingsPage] layout, that displays the [ScanDurationOption].
class SettingsPageSliverScanDurationOption extends StatelessWidget {
  const new({required this.delegate, super.key});

  final ScanDurationDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .macOS || .windows => SliverPadding(
        padding: const .symmetric(horizontal: 12, vertical: 32),
        sliver: SliverToBoxAdapter(child: ScanDurationOption(delegate: delegate)),
      ),
      .iOS => SliverToBoxAdapter(
        child: CupertinoFormSection.insetGrouped(
          header: Builder(builder: (context) => Text(S.of(context).scanSettings.toUpperCase())),
          children: [ScanDurationOption(delegate: delegate)],
        ),
      ),
    };
  }
}
