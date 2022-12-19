import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_details_page_options.dart';
import 'package:weforza/riverpod/member/selected_member_attending_count_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/widgets/dialogs/delete_ride_dialog.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';
import 'package:weforza/widgets/pages/export_ride_page.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/ride_attendee_scanning_page.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideDetailsPage extends ConsumerStatefulWidget {
  const RideDetailsPage({super.key});

  @override
  RideDetailsPageState createState() => RideDetailsPageState();
}

class RideDetailsPageState extends ConsumerState<RideDetailsPage> {
  void _goToScanningPage(BuildContext context) async {
    final updatedRide = await Navigator.of(context).push<Ride>(
      MaterialPageRoute(builder: (_) => const RideAttendeeScanningPage()),
    );

    if (mounted && updatedRide != null) {
      final notifier = ref.read(selectedRideProvider.notifier);

      // Update the selected ride with its new `scannedAttendees` count.
      // The counter gets updates about this value.
      // The attendees list refreshes when the ride is updated.
      //
      // Since the amount of manually added attendees can change, even when
      // [Ride.scannedAttendees] is still the same, this update should be forced.
      notifier.setSelectedRide(updatedRide, force: true);

      // Refresh the ride list so that the attendee counter for this ride
      // updates in the list of rides.
      ref.invalidate(rideListProvider);

      // Refresh the attending count of the selected member.
      ref.invalidate(selectedMemberAttendingCountProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidLayout,
      ios: _buildIOSLayout,
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final translator = S.of(context);

    final errorColor = Theme.of(context).errorColor;

    return Scaffold(
      appBar: AppBar(
        title: const RideDetailsTitle(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            onPressed: () => _goToScanningPage(context),
          ),
          PopupMenuButton<RideDetailsPageOptions>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => <PopupMenuEntry<RideDetailsPageOptions>>[
              PopupMenuItem<RideDetailsPageOptions>(
                value: RideDetailsPageOptions.export,
                child: ListTile(
                  leading: const Icon(Icons.publish),
                  title: Text(translator.Export),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<RideDetailsPageOptions>(
                value: RideDetailsPageOptions.delete,
                child: ListTile(
                  leading: Icon(Icons.delete, color: errorColor),
                  title: Text(
                    translator.Delete,
                    style: TextStyle(color: errorColor),
                  ),
                ),
              ),
            ],
            onSelected: (RideDetailsPageOptions option) {
              onSelectMenuOption(context, option);
            },
          ),
        ],
      ),
      body: const RideDetailsAttendeesList(),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: RideDetailsTitle(),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton(
                  icon: Icons.bluetooth_searching,
                  onPressed: () => _goToScanningPage(context),
                ),
                CupertinoIconButton(
                  icon: CupertinoIcons.ellipsis_vertical,
                  onPressed: () => _showCupertinoModalBottomPopup(context),
                ),
              ],
            ),
          ],
        ),
      ),
      child: const SafeArea(bottom: false, child: RideDetailsAttendeesList()),
    );
  }

  void _onDeleteRideOptionSelected(BuildContext context) {
    showWeforzaDialog(context, builder: (_) => const DeleteRideDialog());
  }

  void onSelectMenuOption(BuildContext context, RideDetailsPageOptions option) {
    switch (option) {
      case RideDetailsPageOptions.export:
        final selectedRide = ref.read(selectedRideProvider);

        assert(selectedRide != null, 'The selected ride was null.');

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExportRidePage(rideToExport: selectedRide!),
          ),
        );
        break;
      case RideDetailsPageOptions.delete:
        _onDeleteRideOptionSelected(context);
        break;
      default:
        break;
    }
  }

  void _showCupertinoModalBottomPopup(BuildContext context) async {
    final translator = S.of(context);

    final option = await showCupertinoModalPopup<RideDetailsPageOptions>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(translator.Export),
              onPressed: () {
                Navigator.of(context).pop(RideDetailsPageOptions.export);
              },
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(RideDetailsPageOptions.delete);
              },
              child: Text(translator.Delete),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(translator.Cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        );
      },
    );

    if (!mounted || option == null) {
      return;
    }

    onSelectMenuOption(context, option);
  }
}
