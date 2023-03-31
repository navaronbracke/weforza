import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/widgets/platform/cupertino_bottom_bar.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the bottom bar for the manual selection page.
///
/// It provides a counter for the ride attendees,
/// a button to save the current scan results
/// and a toggle for the visibility of the scanned results.
class ManualSelectionBottomBar extends StatelessWidget {
  const ManualSelectionBottomBar({
    required this.delegate,
    required this.saveButton,
    required this.showScannedResultsToggle,
    super.key,
  });

  /// The delegate that mannages the scan results.
  final RideAttendeeScanningDelegate delegate;

  /// The button that saves the scan results when tapped.
  final Widget saveButton;

  /// The toggle for the visibility of the scanned results.
  final Widget showScannedResultsToggle;

  Widget _buildAndroidLayout(BuildContext context, BoxConstraints constraints) {
    final attendeeCounter = _buildAttendeeCounter(
      Icon(Icons.people, color: AppTheme.colorScheme.primary),
    );

    final scannedResultsToggle = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.of(context).scannedRiders,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          textAlign: TextAlign.right,
        ),
        showScannedResultsToggle,
      ],
    );

    Widget child = BottomAppBar(
      child: Row(
        children: [
          attendeeCounter,
          Expanded(child: Center(child: saveButton)),
          scannedResultsToggle,
        ],
      ),
    );

    if (constraints.biggest.width < 400) {
      child = BottomAppBar(
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            saveButton,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [attendeeCounter, scannedResultsToggle],
            ),
          ],
        ),
      );
    }

    return child;
  }

  Widget _buildAttendeeCounter(Widget icon, {TextStyle? textStyle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: icon,
        ),
        StreamBuilder<int>(
          initialData: delegate.attendeeCount,
          stream: delegate.attendeeCountStream,
          builder: (context, snapshot) {
            final count = snapshot.data;

            if (count == null) {
              return Text('-', style: textStyle);
            }

            if (count > 999) {
              return Text('999+', style: textStyle);
            }

            return Text('$count', style: textStyle);
          },
        ),
      ],
    );
  }

  Widget _buildIosLayout(BuildContext context, BoxConstraints constraints) {
    final attendeeCounter = _buildAttendeeCounter(
      const Icon(
        CupertinoIcons.person_2_fill,
        color: CupertinoColors.activeBlue,
      ),
      textStyle: const TextStyle(color: CupertinoColors.label, fontSize: 15),
    );

    final scannedResultsToggle = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.of(context).scannedRiders,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: const TextStyle(color: CupertinoColors.label, fontSize: 15),
          textAlign: TextAlign.right,
        ),
        showScannedResultsToggle,
      ],
    );

    Widget child = Row(
      children: [
        attendeeCounter,
        Expanded(child: Center(child: saveButton)),
        scannedResultsToggle,
      ],
    );

    if (constraints.biggest.width < 400) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          saveButton,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [attendeeCounter, scannedResultsToggle],
          ),
        ],
      );
    }

    return CupertinoBottomBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => PlatformAwareWidget(
        android: (ctx) => _buildAndroidLayout(ctx, constraints),
        ios: (ctx) => _buildIosLayout(ctx, constraints),
      ),
    );
  }
}
