import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scan_result.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class is used as the type parameter of [ManualSelectionListItem]'s key.
class _ManualSelectionListItemKey {
  _ManualSelectionListItemKey({
    required this.firstName,
    required this.lastName,
    required this.alias,
  });

  final String firstName;
  final String lastName;
  final String alias;

  @override
  bool operator ==(Object other) {
    return other is _ManualSelectionListItemKey &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        alias == other.alias;
  }

  @override
  int get hashCode => hashValues(firstName, lastName, alias);
}

class ManualSelectionListItem extends StatefulWidget {
  ManualSelectionListItem({
    required this.isSelected,
    required this.isScanned,
    required this.profileImageFuture,
    required this.firstName,
    required this.lastName,
    required this.alias,
    required this.personInitials,
    required this.uuid,
    required this.canTap,
    required this.addScanResult,
    required this.removeScanResult,
    required this.scanResultExists,
  }) : super(
          key: ValueKey<_ManualSelectionListItemKey>(
            _ManualSelectionListItemKey(
              firstName: firstName,
              lastName: lastName,
              alias: alias,
            ),
          ),
        );

  final bool Function() isSelected;
  final bool Function() isScanned;
  final bool Function() canTap;
  final bool Function(RideAttendeeScanResult item) scanResultExists;
  final void Function(String uuid) addScanResult;
  final void Function(RideAttendeeScanResult item) removeScanResult;
  final Future<File?> profileImageFuture;
  final String firstName;
  final String lastName;
  final String alias;
  final String personInitials;
  final String uuid;

  @override
  ManualSelectionListItemState createState() => ManualSelectionListItemState();
}

class ManualSelectionListItemState extends State<ManualSelectionListItem> {
  late Color itemDecorationBackgroundColor;
  late TextStyle firstNameStyle;
  late TextStyle lastNameStyle;
  late bool isSelected;
  late bool isScanned;

  @override
  void initState() {
    super.initState();
    _setColors();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (mounted) {
          // If the search bar still has focus, unfocus it first.
          FocusScope.of(context).unfocus();

          handleTap(context);
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(color: itemDecorationBackgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: PlatformAwareWidget(
                  android: () => AsyncProfileImage(
                    icon: Icons.person,
                    future: widget.profileImageFuture,
                    personInitials: widget.personInitials,
                  ),
                  ios: () => AsyncProfileImage(
                    icon: CupertinoIcons.person_fill,
                    future: widget.profileImageFuture,
                    personInitials: widget.personInitials,
                  ),
                ),
              ),
              Expanded(
                  child: MemberNameAndAlias(
                firstNameStyle: firstNameStyle,
                lastNameStyle: lastNameStyle,
                firstName: widget.firstName,
                lastName: widget.lastName,
                alias: widget.alias,
              )),
              if (isSelected) _buildSelectedIcon()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Icon(
        isScanned ? Icons.bluetooth_searching : Icons.pan_tool_rounded,
        color: Colors.white,
      ),
    );
  }

  void _setColors() {
    isSelected = widget.isSelected();
    isScanned = widget.isScanned();

    if (isSelected) {
      itemDecorationBackgroundColor =
          ApplicationTheme.rideAttendeeSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle
          .copyWith(color: Colors.white);
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle
          .copyWith(color: Colors.white);
    } else {
      itemDecorationBackgroundColor =
          ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle;
    }
  }

  void handleTap(BuildContext context) async {
    // Don't allow selecting the member when locked by saving.
    if (!mounted || !widget.canTap()) {
      return;
    }

    final RideAttendeeScanResult scanResult = RideAttendeeScanResult(
      uuid: widget.uuid,
      isScanned: isScanned,
    );

    // The item exists, remove the item from the results.
    if (widget.scanResultExists(scanResult)) {
      // It's a scanned item, ask for confirmation first.
      if (isScanned) {
        final result = await showConfirmationDialog(context);

        if (result != null && result) {
          widget.removeScanResult(scanResult);
        }
      } else {
        // It's not a scanned item.
        // We can remove it.
        widget.removeScanResult(scanResult);
      }
    } else {
      // The item does not exist.
      // Add it to the results.
      widget.addScanResult(widget.uuid);
    }

    // Rebuild with the new colors.
    setState(() => _setColors());
  }

  Future<bool?> showConfirmationDialog(BuildContext context) {
    final S translator = S.of(context);

    if (Platform.isAndroid) {
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
    }

    if (Platform.isIOS) {
      return showCupertinoDialog(
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
    }

    // For unsupported platforms, allow deselecting the item without a dialog.
    return Future<bool?>.value();
  }
}
