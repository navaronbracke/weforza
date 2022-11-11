import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_device.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the scan results list
/// for the ride attendee scanning page.
class ScanResultsList extends StatelessWidget {
  const ScanResultsList({
    super.key,
    required this.delegate,
    required this.progressBar,
    required this.scanResultsListKey,
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
    return WillPopScope(
      onWillPop: delegate.stopScan,
      child: Column(
        children: [
          progressBar,
          Expanded(
            child: AnimatedList(
              key: scanResultsListKey,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: _ScanResultsListItem(
                    device: delegate.getScannedDevice(index),
                  ),
                );
              },
            ),
          ),
          StopScanButton(delegate: delegate),
        ],
      ),
    );
  }
}

/// This widget represents a single item for the [ScanResultsList].
class _ScanResultsListItem extends StatelessWidget {
  const _ScanResultsListItem({required this.device});

  final ScannedDevice device;

  Widget _buildMultipleOwnersListItem(BuildContext context, int ownersLength) {
    IconData icon;
    Color color;

    switch (Theme.of(context).platform) {
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

    final textStyle = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 12,
      color: color,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(icon, color: textStyle.color),
              ),
              SelectableText(
                device.name,
                scrollPhysics: const ClampingScrollPhysics(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            S.of(context).AmountOfRidersWithDeviceName(ownersLength),
            style: textStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleOwnerListItem(BuildContext context) {
    Color color;
    IconData icon;

    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        color = theme.primaryColor;
        icon = Icons.person;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        color = CupertinoTheme.of(context).primaryColor;
        icon = CupertinoIcons.person_fill;
        break;
    }

    final textStyle = TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    );

    final owner = device.owners.first;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(icon, color: textStyle.color),
        ),
        MemberNameAndAlias.singleLine(
          alias: owner.alias,
          firstName: owner.firstName,
          lastName: owner.lastName,
          style: textStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (device.owners.length) {
      case 0:
        child = Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: PlatformAwareWidget(
                android: (_) => const Icon(
                  Icons.device_unknown,
                  color: Colors.grey,
                ),
                ios: (_) => const Icon(
                  Icons.device_unknown,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            SelectableText(
              device.name,
              scrollPhysics: const ClampingScrollPhysics(),
            ),
          ],
        );
        break;
      case 1:
        child = _buildSingleOwnerListItem(context);
        break;
      default:
        child = _buildMultipleOwnersListItem(context, device.owners.length);
        break;
    }

    return Padding(padding: const EdgeInsets.all(4), child: child);
  }
}
