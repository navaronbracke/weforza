import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';
import 'package:weforza/widgets/dialogs/unselect_scanned_rider_dialog.dart';
import 'package:weforza/widgets/theme.dart';

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
  BoxDecoration? _getDecoration(BuildContext context, bool isSelected) {
    if (isSelected) {
      RideAttendeeScanResultTheme theme;

      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          theme = AppTheme.rideAttendeeScanResult.android;
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          theme = AppTheme.rideAttendeeScanResult.ios;
          break;
      }

      return BoxDecoration(color: theme.selectedBackgroundColor);
    }

    return null;
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

    // The text color uses the Theme's default when unselected.
    final textColor = isSelected ? Colors.white : null;
    const theme = AppTheme.memberListItem;
    final firstNameStyle = theme.firstNameStyle.copyWith(color: textColor);
    final lastNameStyle = theme.lastNameStyle.copyWith(color: textColor);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // If the search bar still has focus, unfocus it first.
        FocusScope.of(context).unfocus();

        final accepted = await widget.delegate.toggleSelectionForActiveMember(
          ScannedRideAttendee(uuid: widget.item.uuid, isScanned: isScanned),
          () async {
            final result = await showWeforzaDialog<bool>(
              context,
              builder: (_) => const UnselectScannedRiderDialog(),
            );

            return result ?? false;
          },
        );

        if (!mounted || !accepted) {
          return;
        }

        setState(() {});
      },
      child: Container(
        decoration: _getDecoration(context, isSelected),
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
