import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/widgets/common/rider_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents a selectable owner list item for the unresolved owners list or the manual selection list.
class SelectableOwnerListItem extends StatelessWidget {
  const new({required this.onTap, required this.rider, required this.selected, this.trailing, super.key});

  /// The onTap handler for this item.
  final void Function() onTap;

  /// The rider that represents this list item.
  final Rider rider;

  /// Whether this [rider] is selected.
  final bool selected;

  /// The trailing widget that is displayed at the trailing edge of this item.
  final Widget? trailing;

  Color _getSelectedBackgroundColor(BuildContext context) {
    switch (defaultTargetPlatform) {
      case .android:
      case .fuchsia:
      case .linux:
      case .windows:
        final ColorScheme colorScheme = ColorScheme.of(context);

        return switch (Theme.brightnessOf(context)) {
          .dark => colorScheme.onPrimary,
          .light => colorScheme.primary,
        };
      case .iOS:
      case .macOS:
        return CupertinoTheme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTheme.riderTextTheme;
    TextStyle firstNameStyle = textTheme.firstNameStyle;
    TextStyle lastNameStyle = textTheme.lastNameStyle;

    if (selected) {
      firstNameStyle = firstNameStyle.copyWith(color: Colors.white);
      lastNameStyle = lastNameStyle.copyWith(color: Colors.white);
    }

    Widget child = Padding(
      padding: const .symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Padding(padding: const .only(right: 4), child: AdaptiveProfileImage.fromRider(rider)),
          Expanded(
            child: RiderNameAndAlias.twoLines(
              alias: rider.alias,
              firstLineStyle: firstNameStyle,
              firstName: rider.firstName,
              lastName: rider.lastName,
              secondLineStyle: lastNameStyle,
            ),
          ),
          if (trailing case final trailing?) Padding(padding: const .only(left: 4), child: trailing),
        ],
      ),
    );

    if (selected) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: _getSelectedBackgroundColor(context)),
        child: child,
      );
    }

    return GestureDetector(behavior: .opaque, onTap: onTap, child: child);
  }
}
