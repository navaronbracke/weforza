import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/generic_scan_error.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_button.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget represents the list of unresolved owners
/// that is shown after a device scan has ended.
class UnresolvedOwnersList extends StatefulWidget {
  /// The default constructor.
  const UnresolvedOwnersList({super.key, required this.delegate});

  final RideAttendeeScanningDelegate delegate;

  @override
  State<UnresolvedOwnersList> createState() => _UnresolvedOwnersListState();
}

class _UnresolvedOwnersListState extends State<UnresolvedOwnersList> {
  Future<List<Member>>? _future;

  /// Filter out the owners that have already been scanned
  /// and sort the remaining unresolved owners.
  Future<List<Member>> _filterAndSortItems() {
    final filtered = widget.delegate.getUnresolvedDeviceOwners();

    filtered.sort((Member m1, Member m2) => m1.compareTo(m2));

    return Future.value(filtered);
  }

  @override
  void initState() {
    super.initState();
    _future = _filterAndSortItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: GenericScanError());
          }

          final items = snapshot.data ?? [];
          final translator = S.of(context);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Center(
                  child: Text(
                    translator.UnresolvedOwnersDescription,
                    style: ApplicationTheme.multipleOwnersListTooltipStyle,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _UnresolvedOwnersListItem(
                      delegate: widget.delegate,
                      item: items[index],
                    );
                  },
                  itemCount: items.length,
                ),
              ),
              Center(
                child: ScanButton(
                  onPressed: () => widget.delegate.continueToManualSelection(),
                  text: translator.Continue,
                ),
              ),
            ],
          );
        }

        return const Center(child: PlatformAwareLoadingIndicator());
      },
    );
  }
}

class _UnresolvedOwnersListItem extends StatefulWidget {
  _UnresolvedOwnersListItem({
    required this.delegate,
    required this.item,
  }) : scanResultEntry = ScannedRideAttendee(uuid: item.uuid, isScanned: false);

  final RideAttendeeScanningDelegate delegate;

  final Member item;

  final ScannedRideAttendee scanResultEntry;

  @override
  State<_UnresolvedOwnersListItem> createState() =>
      _UnresolvedOwnersListItemState();
}

class _UnresolvedOwnersListItemState extends State<_UnresolvedOwnersListItem> {
  late Color backgroundColor;
  late TextStyle firstNameStyle;
  late TextStyle lastNameStyle;

  void _setColors() {
    if (widget.delegate.isSelectedRideAttendee(widget.scanResultEntry)) {
      backgroundColor = ApplicationTheme.rideAttendeeSelectedBackgroundColor;
      firstNameStyle =
          ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
        color: Colors.white,
      );
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
        color: Colors.white,
      );

      return;
    }

    backgroundColor = ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
    firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle;
    lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle;
  }

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
        // Unresolved owners are never initially scanned.
        // Thus showing a confirmation dialog before unselecting
        // an item in the list is redundant.
        widget.delegate.toggleSelectionForItem(widget.scanResultEntry);

        if (!mounted) {
          return;
        }

        setState(() => _setColors());
      },
      child: DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: MemberNameAndAlias(
            firstLineStyle: firstNameStyle,
            secondLineStyle: lastNameStyle,
            firstName: widget.item.firstname,
            lastName: widget.item.lastname,
            alias: widget.item.alias,
          ),
        ),
      ),
    );
  }
}
