import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';

/// This widget represents an item in the manual selection list.
class ManualSelectionListItem extends ConsumerStatefulWidget {
  ManualSelectionListItem({
    required this.delegate,
    required this.item,
  }) : super(key: ValueKey(item.uuid));

  final RideAttendeeScanningDelegate delegate;

  final Member item;

  @override
  ConsumerState<ManualSelectionListItem> createState() =>
      _ManualSelectionListItemState();
}

class _ManualSelectionListItemState
    extends ConsumerState<ManualSelectionListItem> {
  /// Show a confirmation dialog for unselecting a scanned item.
  /// Unselecting a scanned item is a destructive operation since it reduces
  /// the amount of items that have been automatically resolved during a device scan.
  ///
  /// Therefor showing a dialog is preferred over just allowing the item to be unselected.
  Future<bool?> _showConfirmUnselectingScannedItemDialog(BuildContext context) {
    final translator = S.of(context);

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return showCupertinoDialog<bool>(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(translator.UncheckRiderTitle),
            content: Text(translator.UncheckRiderDescription),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text(translator.Uncheck),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              CupertinoDialogAction(
                child: Text(translator.Cancel),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );
      case TargetPlatform.android:
        return showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(translator.UncheckRiderTitle),
            content: Text(translator.UncheckRiderDescription),
            actions: [
              TextButton(
                child: Text(
                  translator.Uncheck,
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              TextButton(
                child: Text(translator.Cancel, textAlign: TextAlign.end),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        // For unsupported platforms,
        // allow deselecting the item without a dialog.
        return Future<bool?>.value();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRideAttendee = widget.delegate.getSelectedRideAttendee(
      widget.item.uuid,
    );

    bool isSelected = false;
    bool isScanned = false;

    if (selectedRideAttendee != null) {
      isSelected = true;
      isScanned = selectedRideAttendee.isScanned;
    }

    final backgroundColor = isSelected
        ? ApplicationTheme.rideAttendeeSelectedBackgroundColor
        : ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;

    // The text color uses the Theme's default when unselected.
    final textColor = isSelected ? Colors.white : null;
    final firstNameStyle =
        ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
      color: textColor,
    );
    final lastNameStyle =
        ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
      color: textColor,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // If the search bar still has focus, unfocus it first.
        FocusScope.of(context).unfocus();

        final accepted = await widget.delegate.toggleSelectionForActiveMember(
          ScannedRideAttendee(uuid: widget.item.uuid, isScanned: isScanned),
          () => _showConfirmUnselectingScannedItemDialog(context),
        );

        if (!mounted || !accepted) {
          return;
        }

        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(color: backgroundColor),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: AdaptiveProfileImage.path(
                imagePath: widget.item.profileImageFilePath,
                personInitials: widget.item.initials,
              ),
            ),
            Expanded(
              child: MemberNameAndAlias(
                alias: widget.item.alias,
                firstLineStyle: firstNameStyle,
                firstName: widget.item.firstName,
                lastName: widget.item.lastName,
                secondLineStyle: lastNameStyle,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  isScanned
                      ? Icons.bluetooth_searching
                      : Icons.pan_tool_rounded,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
