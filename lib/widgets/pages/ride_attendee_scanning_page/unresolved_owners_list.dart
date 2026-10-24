import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/utils/comparators/rider_comparator.dart';
import 'package:weforza/widgets/custom/scroll_behavior.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/generic_scan_error.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_button.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/selectable_owner_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget represents the list of unresolved owners
/// that is shown after a device scan has ended.
class UnresolvedOwnersList extends StatefulWidget {
  /// The default constructor.
  const new({required this.delegate, super.key});

  final RideAttendeeScanningDelegate delegate;

  @override
  State<UnresolvedOwnersList> createState() => _UnresolvedOwnersListState();
}

class _UnresolvedOwnersListState extends State<UnresolvedOwnersList> {
  Future<List<Rider>>? _future;

  /// Filter out the owners that have already been scanned
  /// and sort the remaining unresolved owners.
  Future<List<Rider>> _filterAndSortItems() async {
    final filtered = widget.delegate.getUnresolvedDeviceOwners();

    filtered.sort(compareRiders);

    return filtered;
  }

  TextStyle _getMultipleOwnersListDescriptionStyle(BuildContext context) {
    final color = switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .windows => null,
      .iOS || .macOS => const CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemGrey,
        darkColor: CupertinoColors.white,
      ),
    };

    return TextStyle(
      fontStyle: .italic,
      fontSize: 14,
      color: color is CupertinoDynamicColor ? color.resolveFrom(context) : color,
    );
  }

  @override
  void initState() {
    super.initState();
    _future = _filterAndSortItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rider>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == .done) {
          if (snapshot.hasError) {
            return const Center(child: GenericScanError());
          }

          final items = snapshot.data ?? [];
          final translator = S.of(context);

          return Column(
            children: [
              Padding(
                padding: const .only(bottom: 4, left: 8, right: 8),
                child: Text(
                  translator.unresolvedOwnersDescription,
                  style: _getMultipleOwnersListDescriptionStyle(context),
                  softWrap: true,
                  textAlign: .center,
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  // Use a custom scroll behavior that does not build a stretching overscroll indicator.
                  // Otherwise there are issues with gaps in the selected color of adjacent selected items results.
                  behavior: const NoOverscrollIndicatorScrollBehavior(),
                  child: ListView.builder(
                    itemBuilder: (_, index) => _UnresolvedOwnersListItem(delegate: widget.delegate, item: items[index]),
                    itemCount: items.length,
                  ),
                ),
              ),
              ScanButton(onPressed: widget.delegate.continueToManualSelection, text: translator.continueLabel),
            ],
          );
        }

        return const Center(child: PlatformAwareLoadingIndicator());
      },
    );
  }
}

class _UnresolvedOwnersListItem extends StatefulWidget {
  new({required this.delegate, required this.item}) : super(key: ValueKey(item.id));

  final RideAttendeeScanningDelegate delegate;

  final Rider item;

  @override
  State<_UnresolvedOwnersListItem> createState() => _UnresolvedOwnersListItemState();
}

class _UnresolvedOwnersListItemState extends State<_UnresolvedOwnersListItem> {
  @override
  Widget build(BuildContext context) {
    final selectedRideAttendee = widget.delegate.getSelectedRideAttendee(widget.item.id);

    return SelectableOwnerListItem(
      rider: widget.item,
      selected: selectedRideAttendee != null,
      onTap: () {
        // Unresolved owners are never initially scanned.
        // Thus showing a confirmation dialog before unselecting
        // an item in the list is redundant.
        final scanResultEntry = ScannedRideAttendee(id: widget.item.id, isScanned: false);

        widget.delegate.toggleSelectionForUnresolvedOwner(scanResultEntry);

        setState(() {});
      },
    );
  }
}
