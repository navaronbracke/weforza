import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_device.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

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
    TextStyle style;

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        icon = Icons.people;
        final theme = AppTheme.rideAttendeeScanResult.android;
        style = theme.multipleOwnersLabelStyle;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        icon = CupertinoIcons.person_2_fill;
        final theme = AppTheme.rideAttendeeScanResult.ios;
        style = theme.multipleOwnersLabelStyle;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(icon, color: style.color),
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
            style: style,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleOwnerListItem(BuildContext context) {
    final owner = device.owners.first;
    TextStyle textStyle;
    Widget icon;

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        textStyle = TextStyle(
          color: AppTheme.rideAttendeeScanResult.android.singleOwnerColor,
          fontWeight: FontWeight.bold,
        );
        icon = Icon(Icons.person, color: textStyle.color);
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        textStyle = TextStyle(
          color: AppTheme.rideAttendeeScanResult.ios.singleOwnerColor,
          fontWeight: FontWeight.bold,
        );
        icon = Icon(CupertinoIcons.person_fill, color: textStyle.color);
        break;
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: icon,
        ),
        MemberNameAndAlias(
          alias: owner.alias,
          firstLineStyle: textStyle,
          firstName: owner.firstName,
          isTwoLine: false,
          lastName: owner.lastName,
          secondLineStyle: textStyle,
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
