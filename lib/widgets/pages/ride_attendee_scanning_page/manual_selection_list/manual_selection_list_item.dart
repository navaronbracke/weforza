import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/widgets/dialogs/unselect_scanned_rider_dialog.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/selectable_owner_list_item.dart';

/// This widget represents an item in the manual selection list.
class ManualSelectionListItem extends ConsumerStatefulWidget {
  new({required this.delegate, required this.item}) : super(key: ValueKey(item.id));

  final RideAttendeeScanningDelegate delegate;

  final Rider item;

  @override
  ConsumerState<ManualSelectionListItem> createState() => _ManualSelectionListItemState();
}

class _ManualSelectionListItemState extends ConsumerState<ManualSelectionListItem> {
  @override
  Widget build(BuildContext context) {
    final selectedRideAttendee = widget.delegate.getSelectedRideAttendee(widget.item.id);

    final bool isSelected = selectedRideAttendee != null;
    final bool isScanned = selectedRideAttendee?.isScanned ?? false;

    return SelectableOwnerListItem(
      rider: widget.item,
      selected: isSelected,
      trailing: isSelected
          ? Icon(isScanned ? Icons.bluetooth_searching : Icons.pan_tool_rounded, color: Colors.white)
          : null,
      onTap: () async {
        // If the search bar still has focus, unfocus it first.
        FocusScope.of(context).unfocus();

        final accepted = await widget.delegate.toggleSelectionForActiveRider(
          ScannedRideAttendee(id: widget.item.id, isScanned: isScanned),
          () async {
            final result = await showAdaptiveDialog<bool>(
              context: context,
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
    );
  }
}
