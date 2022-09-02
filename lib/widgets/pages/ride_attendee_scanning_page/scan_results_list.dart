import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_device.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/stop_scan_button.dart';
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
                    device: delegate.getScanResult(index),
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

  Widget _buildMultipleOwnersListItem(String amountOfOwnersLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: PlatformAwareWidget(
                  android: () => const Icon(
                    Icons.people,
                    color: ApplicationTheme.multipleOwnerColor,
                  ),
                  ios: () => const Icon(
                    CupertinoIcons.person_2_fill,
                    color: ApplicationTheme.multipleOwnerColor,
                  ),
                ),
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
            amountOfOwnersLabel,
            style: ApplicationTheme.multipleOwnersLabelStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleOwnerListItem() {
    final owner = device.owners.first;
    const textStyle = TextStyle(
      color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
      fontWeight: FontWeight.bold,
    );

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: PlatformAwareWidget(
            android: () => const Icon(
              Icons.person,
              color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
            ),
            ios: () => const Icon(
              CupertinoIcons.person_fill,
              color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
            ),
          ),
        ),
        MemberNameAndAlias(
          alias: owner.alias,
          firstName: owner.firstname,
          firstLineStyle: textStyle,
          lastName: owner.lastname,
          secondLineStyle: textStyle,
          isTwoLine: false,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    // Build a list item for an unknown device.
    if (device.owners.isEmpty) {
      child = Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(Icons.device_unknown, color: Colors.black),
          ),
          SelectableText(
            device.name,
            scrollPhysics: const ClampingScrollPhysics(),
          ),
        ],
      );
    }

    if (device.owners.length == 1) {
      child = _buildSingleOwnerListItem();
    }

    child = _buildMultipleOwnersListItem(
      S.of(context).AmountOfRidersWithDeviceName(device.owners.length),
    );

    return Padding(padding: const EdgeInsets.all(4), child: child);
  }
}
