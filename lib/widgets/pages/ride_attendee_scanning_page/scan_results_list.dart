import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/bluetooth_peripheral_with_owners.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/widgets/common/rider_name_and_alias.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the scan results list
/// for the ride attendee scanning page.
class ScanResultsList extends StatelessWidget {
  const ScanResultsList({
    required this.delegate,
    required this.progressBar,
    required this.scanResultsListKey,
    super.key,
  });

  /// The delegate that manages the device scan.
  final RideAttendeeScanningDelegate delegate;

  /// The widget that represents the progress bar
  /// for the remaining scan duration.
  final Widget progressBar;

  /// The key for the scan results list.
  final GlobalKey<AnimatedListState> scanResultsListKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        progressBar,
        Expanded(
          child: AnimatedList(
            key: scanResultsListKey,
            initialItemCount: delegate.scannedPeripheralsLength,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: _ScanResultsListItem(peripheral: delegate.getScannedPeripheral(index)),
              );
            },
          ),
        ),
        StopScanButton(delegate: delegate),
      ],
    );
  }
}

/// This widget represents a single item for the [ScanResultsList].
class _ScanResultsListItem extends StatelessWidget {
  const _ScanResultsListItem({required this.peripheral});

  final BluetoothPeripheralWithOwners peripheral;

  Widget _buildMultipleOwnersListItem(BuildContext context) {
    IconData icon;
    Color color;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        icon = Icons.people;
        color = Colors.orange;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        icon = CupertinoIcons.person_2_fill;
        color = CupertinoColors.activeOrange;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Padding(padding: const EdgeInsets.only(right: 4), child: Icon(icon, color: color)),
                SelectableText(peripheral.device.deviceName, scrollPhysics: const ClampingScrollPhysics()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              S.of(context).amountOfRidersWithDeviceName(peripheral.owners.length),
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: color),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleOwnerListItem(BuildContext context) {
    Color color;
    IconData icon;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        color = Theme.of(context).primaryColor;
        icon = Icons.person;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        color = CupertinoTheme.of(context).primaryColor;
        icon = CupertinoIcons.person_fill;
        break;
    }

    final textStyle = TextStyle(color: color, fontWeight: FontWeight.bold);
    final deviceOwner = peripheral.owners.first;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.only(right: 4), child: Icon(icon, color: textStyle.color)),
          RiderNameAndAlias.singleLine(
            alias: deviceOwner.alias,
            firstName: deviceOwner.firstName,
            lastName: deviceOwner.lastName,
            style: textStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildUnknownDeviceListItem() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: PlatformAwareWidget(
              android: (_) => const Icon(Icons.device_unknown, color: Colors.grey),
              ios: (_) => const Icon(Icons.device_unknown, color: CupertinoColors.systemGrey),
            ),
          ),
          SelectableText(peripheral.device.deviceName, scrollPhysics: const ClampingScrollPhysics()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (peripheral.owners.length) {
      case 0:
        return _buildUnknownDeviceListItem();
      case 1:
        return _buildSingleOwnerListItem(context);
      default:
        return _buildMultipleOwnersListItem(context);
    }
  }
}
