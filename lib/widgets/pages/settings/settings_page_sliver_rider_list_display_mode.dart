/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/rider_list_display_mode_delegate.dart';
import 'package:weforza/widgets/pages/settings/rider_list_display_mode_option.dart';

/// A sliver widget for inside the [SettingsPage] layout, that displays the [RiderListDisplayModeOption].
class SettingsPageSliverRiderListDisplayMode extends StatelessWidget {
  const new({required this.delegate, super.key});

  final RiderListDisplayModeDelegate delegate;

  @override
  Widget build(BuildContext context) {
    final S translator = S.of(context);

    return switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .macOS || .windows => SliverPadding(
        padding: const .fromLTRB(12, 16, 12, 8),
        sliver: SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              final textTheme = TextTheme.of(context);

              return Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(translator.ridersListDisplayMode, style: textTheme.titleMedium),
                  RiderListDisplayModeOption(delegate: delegate),
                  Text(
                    translator.ridersListDisplayModeDescription,
                    style: textTheme.bodySmall?.copyWith(fontStyle: .italic),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      .iOS => SliverToBoxAdapter(
        child: CupertinoFormSection.insetGrouped(
          header: Text(translator.riders.toUpperCase()),
          footer: Text(translator.ridersListDisplayModeDescription),
          children: [
            Padding(
              padding: const .all(6),
              child: Center(child: RiderListDisplayModeOption(delegate: delegate)),
            ),
          ],
        ),
      ),
    };
  }
}
