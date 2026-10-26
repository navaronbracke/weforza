/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/settings/reset_ride_calendar_button.dart';

/// A sliver widget for inside the [SettingsPage] layout, that displays the [ResetRideCalendarButton].
class SettingsPageSliverResetRideCalendarButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .macOS || .windows => const SliverPadding(
        padding: .fromLTRB(24, 56, 24, 0),
        sliver: SliverToBoxAdapter(child: Center(child: ResetRideCalendarButton())),
      ),
      .iOS => SliverPadding(
        padding: const .symmetric(vertical: 32),
        sliver: SliverToBoxAdapter(
          child: CupertinoFormSection.insetGrouped(
            header: Builder(builder: (context) => Text(S.of(context).rideCalendar.toUpperCase())),
            children: const [
              CupertinoFormRow(
                padding: EdgeInsetsDirectional.only(start: 20, end: 6),
                prefix: ResetRideCalendarButton(),
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    };
  }
}
