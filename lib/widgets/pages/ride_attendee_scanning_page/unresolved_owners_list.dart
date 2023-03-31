import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/generic_scan_error.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_button.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/theme.dart';

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

  TextStyle _getMultipleOwnersListDescriptionStyle(BuildContext context) {
    Color color;

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        color = Colors.grey;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        color = CupertinoColors.systemGrey;
        break;
    }

    return TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: color);
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
                    style: _getMultipleOwnersListDescriptionStyle(context),
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
              ScanButton(
                onPressed: widget.delegate.continueToManualSelection,
                text: translator.Continue,
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
  }) : super(key: ValueKey(item.uuid));

  final RideAttendeeScanningDelegate delegate;

  final Member item;

  @override
  State<_UnresolvedOwnersListItem> createState() =>
      _UnresolvedOwnersListItemState();
}

class _UnresolvedOwnersListItemState extends State<_UnresolvedOwnersListItem> {
  Color _getSelectedBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return theme.primaryColorDark;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoTheme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedAttendee = widget.delegate.getSelectedRideAttendee(
      widget.item.uuid,
    );

    const textTheme = AppTheme.riderTextTheme;

    TextStyle firstNameStyle = textTheme.firstNameStyle;
    TextStyle lastNameStyle = textTheme.lastNameStyle;

    if (selectedAttendee != null) {
      firstNameStyle = firstNameStyle.copyWith(color: Colors.white);
      lastNameStyle = lastNameStyle.copyWith(color: Colors.white);
    }

    Widget child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: MemberNameAndAlias.twoLines(
        alias: widget.item.alias,
        firstLineStyle: firstNameStyle,
        firstName: widget.item.firstName,
        lastName: widget.item.lastName,
        secondLineStyle: lastNameStyle,
      ),
    );

    if (selectedAttendee != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: _getSelectedBackgroundColor(context)),
        child: child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Unresolved owners are never initially scanned.
        // Thus showing a confirmation dialog before unselecting
        // an item in the list is redundant.
        final scanResultEntry = ScannedRideAttendee(
          uuid: widget.item.uuid,
          isScanned: false,
        );

        widget.delegate.toggleSelectionForUnresolvedOwner(scanResultEntry);

        if (!mounted) {
          return;
        }

        setState(() {});
      },
      child: child,
    );
  }
}
